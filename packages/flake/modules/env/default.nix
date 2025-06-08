{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.env = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }:
      with lib; let
        # Function to generate the export string from the attribute set
        generateExportString = envAttrs:
          concatStringsSep "\n" (
            mapAttrsToList (name: value: "export ${name}=${value}") envAttrs
          );
      in {
        options.snowblower = {
          env = lib.mkOption {
            type = types.submoduleWith {
              modules = [
                (_env: {
                  config._module.freeformType = types.lazyAttrsOf types.anything;
                })
              ];
            };
            description = "Environment variables to be exposed inside the developer environment.";
            default = {};
          };
          core = {
            packages.environment = mkOption {
              type = types.package;
              internal = true;
            };
          };
        };

        config.snowblower = {
          # Default env
          env = {
            "PROJECT_ROOT" = toString config.snowblower.paths.root;
            "PROJECT_DOTFILE" = toString config.snowblower.paths.snowblowerDir;

            "PROJECT_PROFILE" = toString config.snowblower.paths.profile;
            "PROJECT_STATE" = toString config.snowblower.paths.state;
            "PROJECT_RUNTIME" = toString config.snowblower.paths.runtime;
          };

          # Credits to https://github.com/srid/flake-root
          # This script first finds the `root` of the snowblower projects it then exports all other env varibles that need to be set at runtime etc.
          core.packages.environment = pkgs.writeShellApplication {
            name = "snowblower-setup-environment";
            text = ''

              find_flake() {
                  ancestors=()
                  while true; do
                  if [[ -f "flake.nix" ]]; then
                      export SNOWBLOWER_ROOT="$PWD"
                      return 0
                  fi
                  ancestors+=("$PWD")
                  if [[ $PWD == / ]] || [[ $PWD == // ]]; then
                      echo "ERROR: Unable to locate the flake.nix in any of: ''${ancestors[*]@Q}" >&2
                      exit 1
                  fi
                  cd ..
                  done
              }

              find_flake
              ${generateExportString config.snowblower.env}
            '';
          };
        };
      });
  };
}
