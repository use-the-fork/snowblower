{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkLanguage;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.snowblower.languages.python;
in {
  imports = [
    ./tools
  ];

  options.snowblower.languages.python = mkLanguage {
    name = "Python";
    package = pkgs.python311;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Python version
        cfg.package
      ];

    # Python environment setup
    home.sessionVariables = {
      # Use uv as the default package manager
      PIP_USE_FEATURE = "fast-deps";
      PYTHONUSERBASE = "$HOME/.local";
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
