{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  imports = [
    ./compose.nix
    ./image.nix
  ];

  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
  in {
    options.snowblower = {
      docker = {
        entrypointPackage = mkOption {
          internal = true;
          type = types.package;
          description = "The package containing the environment docker uses.";
        };
      };
    };

    config = {
      snowblower = {
        docker.entrypointPackage = pkgs.writeScriptBin "with-snowblower" ''
          #!/bin/bash

          export SB_CONTAINER_NAME="$CONTAINER_NAME"
          export SB_SERVICE_NAME="$SERVICE_NAME"

          # Save the first argument
          command="$1"
          shift

          case "$command" in
            exec)
              exec "$@"
              ;;
            *)
              sleep inf
              ;;
          esac
        '';

        packages.runtime = [
          config.snowblower.docker.entrypointPackage
        ];
      };
    };
  });
}
