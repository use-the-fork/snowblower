{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;

    serviceModule = {
      imports = [./../lib/types/service-module.nix];
      config._module.args = {inherit pkgs;};
    };
    serviceType = types.submodule serviceModule;

    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [
      {
        options.snowblower.docker.services = mkOption {
          type = types.submoduleWith {
            modules = [{freeformType = types.attrsOf serviceType;}];
            specialArgs = {inherit pkgs;};
          };
          default = {};
          description = ''
            The services that are available to docker-compose
          '';
        };
      }
    ];

    options.snowblower = {
      docker.common = mkOption {
        inherit (yamlFormat) type;
        default = {};
        description = ''
          Common configuration to be shared across services using Docker Compose's YAML anchors.
          This will be added as 'x-snowblower-common' in the generated docker-compose.yml.
        '';
        example = lib.literalExpression ''
          {
            restart = "always";
            init = true;
          }
        '';
      };
    };

    config.snowblower = let
      # Extract service configurations
      composeServices =
        lib.mapAttrs (_name: service: service.outputs.service)
        config.snowblower.docker.services;

      # Extract networks from services
      serviceNetworks = lib.unique (lib.flatten (
        lib.mapAttrsToList (
          _name: service:
            if service.enable && service.networks != []
            then service.networks
            else []
        )
        config.snowblower.docker.services
      ));

      # Create networks configuration
      networksConfig = lib.listToAttrs (map (name: {
          inherit name;
          value = {};
        })
        serviceNetworks);

      # Create the compose configuration
      composeConfig =
        {
          "x-snowblower-common" = config.snowblower.docker.common;
          services = composeServices;
        }
        // lib.optionalAttrs (serviceNetworks != []) {
          networks = networksConfig;
        };

      # Create Dockerfile content
      dockerfileContent = ''
        FROM docker.io/use-the-fork/snowblower-base:latest

        COPY flake.nix /home/''${USERNAME}/flake.nix
        COPY flake.lock /home/''${USERNAME}/flake.lock

        RUN nix profile install /home/''${USERNAME}#snowblower-container
      '';
    in {
      docker = {
        common = {
          build = {
            context = ".";
            dockerfile = "./docker/Dockerfile";
            args = {
              USER_UID = "\${USER_UID}";
              USER_GID = "\${USER_GID}";
            };
          };
          environment = {
            USER_GID = "\${USER_GID}";
          };
          volumes = [
            ".:/workspace"
          ];
          working_dir = "/workspace";
          tty = true;
        };

        services.dev = {
          enable = true;
          service = {
            build = {
              context = ".";
              dockerfile = "./docker/Dockerfile";
              args = {
                USER_UID = "\${USER_UID}";
                USER_GID = "\${USER_GID}";
              };
            };
            environment = {
              USER_GID = "\${USER_GID}";
            };
            volumes = [
              ".:/workspace"
            ];
            working_dir = "/workspace";
            tty = true;
          };
        };
      };

      file."docker-compose.yml" = {
        enable = true;
        source = yamlFormat.generate "docker-compose.yml" composeConfig;
      };

      file."docker/Dockerfile" = {
        enable = true;
        source = pkgs.writeText "dockerfile" dockerfileContent;
      };
    };
  });
}
