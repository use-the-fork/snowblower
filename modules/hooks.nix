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
    inherit (lib.sbl.hooks) mkHook;
  in {
    imports = [
    ];

    options.snowblower = {
      hook = {
        switch = {
          activation = mkOption {
            type = lib.sbl.types.dagOf types.str;
            default = {};
            description = ''
            '';
          };
        };

        tools = mkHook {
          name = "Docker Compose Tools Container";
        };

        package = mkOption {
          type = types.package;
          internal = true;
          description = ''
            Foo
          '';
        };
      };
    };

    config.snowblower = {
      hook.package = let
        resolvedHooks = lib.concatStringsSep "\n" (
          map (section: section.name)
          (lib.sbl.dag.resolveDag {
            name = "snowblower command options";
            dag = config.snowblower.command;
            mapResult = lib.id;
          })
        );
      in
        pkgs.writeScriptBin "snowblower-hooks" ''
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
    };
  });
}
