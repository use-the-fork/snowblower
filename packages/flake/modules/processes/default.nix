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
        inherit (config.snowblower) processes;

        processType = types.submodule (_: {
          options = {
            containerService = lib.mkOption {
              type = types.str;
              description = "The Docker Compose service to run this process in";
              default = "dev";
            };
            exec = lib.mkOption {
              type = types.str;
              description = "Command to run in the container";
            };
          };
        });
      in {
        options.snowblower = {
          processes = lib.mkOption {
            type = types.attrsOf processType;
            default = {};
            description = "Processes can be started with ``just up`` and run in foreground mode.";
          };
        };

        config = lib.mkIf (processes != {}) {
          #Expose process-compose as a buildable package.

          snowblower = {
            # Create Docker Compose services for each process
            docker-compose.services =
              lib.mapAttrs (name: process: {
                enable = true;
                service =
                  # Start with the base service configuration
                  (config.snowblower.docker-compose.services.${process.containerService}.service or {})
                  # Override the command with the process exec
                  // {command = process.exec;}
                  # Add a unique name based on the process
                  // {container_name = "${process.containerService}-${name}";};
              })
              processes;

            just.recipes.up = {
              enable = lib.mkDefault true;
              justfile = lib.mkDefault ''
                # Starts the environment.
                up:
                  docker-compose up ${lib.concatStringsSep " " (lib.attrNames processes)}
              '';
            };
          };
        };
      });
  };
}
