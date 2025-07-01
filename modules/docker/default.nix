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
          ${builtins.readFile config.snowblower.utilitiesPackage}

          doSetupColors

          ${builtins.readFile config.snowblower.environmentVariablesPackage}
          export SB_CONTAINER_NAME="$CONTAINER_NAME"
          export SB_SERVICE_NAME="$SERVICE_NAME"

          # Save the first argument
          command="$1"
          shift

          case "$command" in
            exec)
              _iNote "Executing: %s" "$*"
              expanded_args=()
              for arg in "$@"; do
                  expanded_args+=("$(expand_vars "$arg")")
              done
              exec "''${expanded_args[@]}" 2>&1
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
