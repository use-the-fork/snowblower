{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkOption types;

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
            function doSetupEnvironmentVariables() {
              # Only source this once.
              if [ -v __SB_SESS_VARS_SOURCED ]; then return; fi
              export __SB_SESS_VARS_SOURCED=1

              ${lib.sbl.shell.exportAll cfg.environmentVariables}
            }

            doSetupEnvironmentVariables
          '';
        };

        file."snow" = let
          upPreHooks = lib.sbl.dag.resolveDag {
            name = "snowblower up pre hooks";
            dag = config.snowblower.hook.up.pre;
            mapResult = result:
              lib.concatLines (map (entry: entry.data) result);
          };

          activationPackage = pkgs.writeTextFile {
            name = "sb-activation-package";
            text = ''
              ${builtins.readFile config.snowblower.utilitiesPackage}

              ${builtins.readFile ./../lib-bash/snow/boot.sh}

              function doHook__up__pre {
                echo -n
                ${upPreHooks}
              }

              ${builtins.readFile config.snowblower.environmentVariablesPackage}

              ${builtins.readFile ./../lib-bash/help-extra.sh}
              ${builtins.readFile config.snowblower.commandHelpPackage}
              ${builtins.readFile ./../lib-bash/welcome.sh}

              ${builtins.readFile config.snowblower.commandPackage}
            '';
          };

          # we need this to remove keep sorted comments
          snowPackage = lib.sbl.strings.modifyFileContent {
            file = activationPackage;
            substitute = {
              "# keep-sorted start" = "";
              "# keep-sorted end" = "";
              "keep-sorted" = "";
            };
          };
        in {
          enable = true;
          executable = true;
          text = snowPackage;
        };
      };
    };
  });
}
