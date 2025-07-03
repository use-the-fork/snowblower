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
      };
    };
  });
}
