{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.shell = _flakeModule: {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      self',
      ...
    }: let
      inherit (lib) types mkOption;

      cfg = config.snow-blower;

      #          ansi = import ../nix/ansi.nix;

      # Write a bash profile to load
      envBash = pkgs.writeShellScriptBin "devshell-env" ''

        PRJ_ROOT=$FLAKE_ROOT

        if [[ -z "''${PRJ_ROOT:-}" ]]; then
          echo "ERROR: please set the PRJ_ROOT env var to point to the project root" >&2
          return 1
        fi

        export PRJ_ROOT

        ${cfg.shell.startup_env}
      '';
    in {
      options.snow-blower.shell = {
        startup = mkOption {
          type = types.lines;
          description = "Bash code to execute when entering the shell.";
          default = "";
        };

        startup_env = mkOption {
          type = types.str;
          default = "";
          internal = true;
          description = ''
            Please ignore. Used by the env module.
          '';
        };

        stdenv = mkOption {
          type = types.package;
          description = "The stdenv to use for the developer environment.";
          default = pkgs.stdenv;
        };

        shell = mkOption {
          type = types.package;
          internal = true;
        };

        # Outputs
        build = {
          devShell = mkOption {
            description = "The development shell with Snow Blower and its underlying programs";
            type = types.package;
            readOnly = true;
          };
        };
      };

      config.devShells.default = (pkgs.mkShell.override {stdenv = config.snow-blower.shell.stdenv;}) {
        packages = config.snow-blower.packages;
        nativeBuildInputs = [
          self'.packages.watch-server
        ];
        shellHook = ''
              FLAKE_ROOT="''$(${lib.getExe config.flake-root.package})"
              export FLAKE_ROOT

          source ${lib.getExe envBash}
          ${config.snow-blower.shell.startup}
          echo
          echo "❄️ 💨 Snow Blower: Simple, Fast, Declarative, Reproducible, and Composable Developer Environments"
          echo
          echo "Run 'just <recipe>' to get started"
          just --list
        '';
      };
    });
  };
}
