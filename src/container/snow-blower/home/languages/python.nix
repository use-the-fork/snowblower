{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./utils.nix {inherit lib;}) mkLanguage;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.modules.languages.python;

  toml = pkgs.formats.toml {};

in {
  options.modules.languages.python = mkLanguage {
    name = "Python";
    package = pkgs.python311;
    settings = {
      uv = {
        enable = mkEnableOption "W";
        package = mkOption {
          type = types.package;
          default = pkgs.uv;
          description = "uv package to use";
        };
        config = mkOption {
          type = toml.type;
          default = {
            python.python-path = "${cfg.package}/bin/python";
            venv.location = "venvs";
          };
          description = "uv configuration options";
        };
      };

      ruff = {
        enable = mkEnableOption "Whether to enable Ruff linter and formatter";
        package = mkOption {
          type = types.package;
          default = pkgs.ruff;
          description = "Ruff package to use";
        };
      };

    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Python version
        cfg.package

        # Always include uv for python managment
        cfg.settings.uv.package
      ]
      # Add ruff if enabled
      ++ lib.optional cfg.settings.ruff.enable cfg.settings.ruff.package;

    # Python environment setup
    home.sessionVariables = {
      # Use uv as the default package manager
      PIP_USE_FEATURE = "fast-deps";
      PYTHONUSERBASE = "$HOME/.local";
    };

    # Configure uv
    home.file.".config/uv/config.toml" = {
      enable = true;
      source = toml.generate "uv-config" cfg.settings.uv.config;
    };

    # Create Python local directory
    home.activation.createPythonLocalDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.local/bin
    '';

    # Add Python local bin to PATH
    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
