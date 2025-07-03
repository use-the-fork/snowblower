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

        runtime = mkHook {
          name = "Docker Compose Runtime Container";
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

        # Generate hook functions for runtime.pre
        runtimePreHooks = lib.sbl.dag.resolveDag {
          name = "snowblower runtime pre hooks";
          dag = config.snowblower.hook.runtime.pre;
          mapResult = result:
            lib.concatLines (map (entry: entry.data) result);
        };

        # Generate hook functions for runtime.post
        runtimePostHooks = lib.sbl.dag.resolveDag {
          name = "snowblower runtime post hooks";
          dag = config.snowblower.hook.runtime.post;
          mapResult = result:
            lib.concatLines (map (entry: entry.data) result);
        };
      in
        pkgs.writeScriptBin "snowblower-hooks" ''
          #!/bin/bash

          function doHook__tools__pre {
            echo -n
            ${toolsPreHooks}
          }

          function doHook__tools__post {
            echo -n
            ${toolsPostHooks}
          }

          function doHook__runtime__pre {
            echo -n
            ${runtimePreHooks}
          }

          function doHook__runtime__post {
            echo -n
            ${runtimePostHooks}
          }

          hook_name="$1"
          shift

          case "$hook_name" in
            tools_pre)
              doHook__tools__pre "$@"
              exit 0
              ;;
            tools_post)
              doHook__tools__post "$@"
              ;;
            runtime_pre)
              doHook__runtime__pre "$@"
              exit 0
              ;;
            runtime_post)
              doHook__runtime__post "$@"
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
