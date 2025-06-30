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
        up = mkHook {
          name = "Environment Startup";
        };

        tools = mkHook {
          name = "Docker Compose Tools Container";
        };

        package = mkOption {
          type = types.package;
          internal = true;
          description = ''
            Package containing the snowblower-hooks script that executes all configured hooks.
          '';
        };
      };
    };

    config.snowblower = {
      hook.package = let
        # Generate hook functions for up.pre
        upPreHooks = lib.sbl.dag.resolveDag {
          name = "snowblower up pre hooks";
          dag = config.snowblower.hook.up.pre;
          mapResult = result:
            lib.concatLines (map (entry: entry.data) result);
        };

        # Generate hook functions for tools.pre
        toolsPreHooks = lib.sbl.dag.resolveDag {
          name = "snowblower tools pre hooks";
          dag = config.snowblower.hook.tools.pre;
          mapResult = result:
            lib.concatLines (map (entry: entry.data) result);
        };

        # Generate hook functions for tools.post
        toolsPostHooks = lib.sbl.dag.resolveDag {
          name = "snowblower tools post hooks";
          dag = config.snowblower.hook.tools.post;
          mapResult = result:
            lib.concatLines (map (entry: entry.data) result);
        };
      in
        pkgs.writeScriptBin "snowblower-hooks" ''
          #!/bin/bash

          function doHook__up__pre {
            echo
            ${upPreHooks}
          }

          function doHook__tools__pre {
            echo
            ${toolsPreHooks}
          }

          function doHook__tools__post {
            echo
            ${toolsPostHooks}
          }
          hook_name="$1"
          shift

          case "$hook_name" in
            up_pre)
              doHook__up__pre "$@"
              exit 0
              ;;
            tools_pre)
              doHook__tools__pre "$@"
              exit 0
              ;;
            tools_post)
              doHook__tools__post "$@"
              ;;
            *)
              echo "Unknown hook: $hook_name" >&2
              exit 1
              ;;
          esac
        '';

      packages.runtime = [
        config.snowblower.hook.package
      ];
    };
  });
}
