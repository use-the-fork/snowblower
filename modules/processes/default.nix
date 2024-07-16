{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.processes = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }:
      with lib; let
        processType = types.submodule (_: {
          options = {
            command = lib.mkOption {
              type = types.str;
              description = "Bash code to run the process.";
            };

            # TODO: Deprecate this option in favor of `process-managers.process-compose.settings.processes.${name}`.
            process-compose = lib.mkOption {
              type = types.attrs; # TODO: type this explicitly?
              default = {};
              description = ''
                process-compose.yaml specific process attributes.

                Example: https://github.com/F1bonacc1/process-compose/blob/main/process-compose.yaml`

                Only used when using ``process.implementation = "process-compose";``
              '';
              example = {
                environment = ["ENVVAR_FOR_THIS_PROCESS_ONLY=foobar"];
                availability = {
                  restart = "on_failure";
                  backoff_seconds = 2;
                  max_restarts = 5; # default: 0 (unlimited)
                };
                depends_on.some-other-process.condition = "process_completed_successfully";
              };
            };
          };
        });
      in {
        options.snow-blower = {
          processes = lib.mkOption {
            type = types.attrsOf processType;
            default = {};
            description = "Processes can be started with ``devenv up`` and run in foreground mode.";
          };
        };

        config = {
          snow-blower = lib.mkIf (config.process-compose.watch-server.settings.processes != {}) {
            just.recipes.up = {
              enable = lib.mkDefault true;
              justfile = lib.mkDefault ''
                # Starts the environment.
                up:
                  nix run .#watch-server
              '';
            };
          };
        };
      });
  };
}
