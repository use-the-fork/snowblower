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
    inherit (lib.sbl.docker) mkDockerComposeService;

    serviceModule = {
      imports = [./../../lib/types/service-module.nix];
      config._module.args = {inherit pkgs;};
    };
    serviceType = types.submodule serviceModule;

    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [
      {
        options.snowblower.docker.service = mkOption {
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
      docker = {
        common = {
          dependsOn = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              List of services that this service depends on.
              Will be used for the `depends_on` field in docker-compose.
            '';
            example = lib.literalExpression ''[ "db" "redis" ]'';
          };
        };

        commonService = mkOption {
          inherit (yamlFormat) type;
          default = {};
          internal = true;
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
    };

    config = {
      snowblower = let
        # Extract service configurations
        composeServices =
          lib.mapAttrs (_name: service: service.outputs.service)
          config.snowblower.docker.service;

        # Extract networks from services
        serviceNetworks = lib.unique (lib.flatten (
          lib.mapAttrsToList (
            _name: service:
              if service.enable && service.networks != []
              then service.networks
              else []
          )
          config.snowblower.docker.service
        ));

        # Create networks configuration with default snownet
        defaultNetworks = ["snownet"];
        allNetworks = lib.unique (defaultNetworks ++ serviceNetworks);
        networksConfig = lib.listToAttrs (map (name: {
            inherit name;
            value =
              if name == "snownet"
              then {driver = "bridge";}
              else {};
          })
          allNetworks);

        # Create the compose configuration
        composeConfig =
          {
            services = composeServices;
          }
          // {
            networks = networksConfig;
          }
          // {
            volumes = {
              snowblower-nix = {
                external = true;
              };
            };
          };
      in {
        docker = {
          service."runtime" = {
            enable = true;
            service = mkDockerComposeService {
              autoStart = true;
              runtime = true;
            };
          };

          service."tools" = {
            enable = true;
            service = mkDockerComposeService {
              service = {
                image = "${config.snowblower.docker.image.toolsPackage.imageName}:${config.snowblower.docker.image.toolsPackage.imageTag}";
                volumes = [
                  ".:/workspace"
                  "\${SB_PROJECT_PROFILE:-/tmp/snowblower/profile}:/snowblower/profile"
                  "\${SB_PROJECT_STATE:-/tmp/snowblower/state}:/snowblower/state"
                ];
                working_dir = "/workspace";
                environment = {
                  "SB_SERVICE_TYPE" = "tools";
                  "SB_PROJECT_PROFILE" = "/snowblower/profile";
                  "SB_PROJECT_STATE" = "/snowblower/state";
                };
                tty = true;
              };
              autoStart = true;
            };
          };

          service."builder" = {
            enable = true;
            service = mkDockerComposeService {
              service = {
                build = {
                  context = "./";
                  dockerfile = "docker/Dockerfile.builder";
                  args = {
                    "USER_UID" = "\${SB_USER_UID:-1000}";
                    "USER_GID" = "\${SB_USER_GID:-1000}";
                  };
                };
                volumes = [
                  ".:/workspace"
                  "snowblower-nix:/nix"
                  "\${SB_PROJECT_PROFILE:-/tmp/snowblower/profile}:/snowblower/profile"
                  "\${SB_PROJECT_STATE:-/tmp/snowblower/state}:/snowblower/state"
                  "\${SB_PROJECT_ROOT:-/tmp/snowblower}:/snowblower"
                ];
                environment = {
                  "SB_SERVICE_TYPE" = "builder";
                };
              };
              manualStart = true;
            };
          };
        };

        file."docker-compose.yml" = {
          enable = true;
          text = lib.sbl.strings.modifyFileContent {
            file = yamlFormat.generate "docker-compose.yml" composeConfig;
            prepend = ''
              # This file is automatically generated by SnowBlower.
              # Do not edit this file directly as your changes will be overwritten.
              # Instead, modify your flake.nix configuration to update Docker services.
            '';
          };
        };

        # From: https://github.com/tomferon/nix-volume-reuse/blob/master/Dockerfile
        file."docker/Dockerfile.builder" = {
          enable = true;
          source = pkgs.writeText "dockerfileBuilder" ''
            FROM alpine
            RUN apk add curl sudo xz git gcompat bash openssh-client
            RUN echo "snowuser ALL = NOPASSWD: ALL" > /etc/sudoers

            ARG USER_UID=1000
            ARG USER_GID=''${USER_UID}

            RUN addgroup --gid "$USER_UID" snowuser
            RUN adduser -D --uid "$USER_UID" --ingroup snowuser snowuser

            RUN <<EOF
            echo '#!/bin/bash
            # If the nix store volume is empty, initialise it with whatever is in the base
            # image. `/nix` itself might not be empty, e.g. GKE adds a `lost+found` folder.
            # To circumvent this issue, it tests for the presence of `/nix/store` instead.
            if [ ! -e /nix/store ]; then
              cp -Tdar /tmp/nix.orig /nix
            fi

            export USER=snowuser
            source $HOME/.nix-profile/etc/profile.d/nix.sh

            exec "$@"' > /entrypoint.sh
            EOF

            RUN chmod +x /entrypoint.sh

            USER snowuser

            # install nix
            ARG NIX_INSTALL_SCRIPT=https://nixos.org/nix/install
            RUN sh <(curl --proto '=https' --tlsv1.2 -L ''${NIX_INSTALL_SCRIPT}) --no-daemon

            RUN cp -r /nix /tmp/nix.orig

            VOLUME /nix

            RUN mkdir -p /home/snowuser/.config/nix/

            RUN <<EOF
            echo 'sandbox = false
            experimental-features = nix-command flakes
            accept-flake-config = true
            keep-going = true
            warn-dirty = false
            substituters = https://cache.nixos.org https://nix-community.cachix.org https://nixpkgs-unfree.cachix.org
            trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs=
            pure-eval = false' > /home/snowuser/.config/nix/nix.conf
            EOF

            WORKDIR /workspace

            ENTRYPOINT ["bash", "/entrypoint.sh"]
          '';
        };
      };
    };
  });
}
