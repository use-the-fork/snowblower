{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) literalExpression mkOption types;

    cfg = config.snowblower;
  in {
    options.snowblower = {
      environmentVariables = mkOption {
        default = {};
        type = with types;
          lazyAttrsOf (oneOf [
            str
            path
            int
            float
          ]);
        example = {
          EDITOR = "emacs";
        };
        description = ''
          Environment variables to always set.
        '';
      };

      environmentVariablesPackage = mkOption {
        type = types.package;
        internal = true;
      };
    };

    config = {
      snowblower = {
        # Provide a file holding all session variables.
        environmentVariablesPackage = pkgs.writeTextFile {
          name = "sb-session-vars.sh";
          text = ''
            function setupEnvironmentVariables() {
              # Only source this once.
              if [ -v __SB_SESS_VARS_SOURCED ]; then return; fi
              export __SB_SESS_VARS_SOURCED=1

              ${lib.sbl.shell.exportAll cfg.environmentVariables}
            }

            setupEnvironmentVariables
          '';
        };

        file."snow" = let
          activationPackage = pkgs.writeTextFile {
            name = "sb-activation-package";
            text = ''
              ${builtins.readFile ./../lib-bash/utils/head.sh}

              # keep-sorted start
              ${builtins.readFile ./../lib-bash/utils/checks.sh}
              ${builtins.readFile ./../lib-bash/utils/color.sh}
              ${builtins.readFile ./../lib-bash/utils/file.sh}
              ${builtins.readFile ./../lib-bash/utils/output.sh}
              # keep-sorted end

              ${builtins.readFile ./../lib-bash/file-creation.sh}
              ${builtins.readFile config.snowblower.directoriesPackage}
              ${builtins.readFile config.snowblower.touchFilesPackage}

              ${builtins.readFile ./../lib-bash/boot.sh}

              ${builtins.readFile config.snowblower.environmentVariablesPackage}

              ${builtins.readFile ./../lib-bash/welcome.sh}
              ${builtins.readFile config.snowblower.commandHelpPackage}

              ${builtins.readFile config.snowblower.commandPackage}
            '';
          };
        in {
          enable = true;
          executable = true;
          source = activationPackage;
        };
      };
    };
  });
}
