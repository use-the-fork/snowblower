{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkOption types;
  in {
    options.snowblower = {
      # The projectHash has to be
      # - unique to each PROJECT to let multiple snowblower images coexist
      # - deterministic so that it won't change constantly
      projectHash = mkOption {
        type = types.str;
        internal = true;
        default = builtins.getEnv "SB_PROJECT_HASH";
      };
    };

    config = {
      snowblower = {
        file."snow" = let
          upPreHooks = lib.sbl.dag.resolveDag {
            name = "snowblower up pre hooks";
            dag = config.snowblower.hook.up.pre;
            mapResult = result:
              lib.concatLines (map (entry: entry.data) result);
          };

          upPostHooks = lib.sbl.dag.resolveDag {
            name = "snowblower up post hooks";
            dag = config.snowblower.hook.up.post;
            mapResult = result:
              lib.concatLines (map (entry: entry.data) result);
          };

          activationPackage = pkgs.writeTextFile {
            name = "sb-activation-package";
            text = ''
              ${builtins.readFile config.snowblower.utilitiesPackage}

              # keep-sorted start
              ${builtins.readFile ./../lib-bash/snow/bash.sh}
              ${builtins.readFile ./../lib-bash/snow/boot.sh}
              ${builtins.readFile ./../lib-bash/snow/build.sh}
              ${builtins.readFile ./../lib-bash/snow/command-execute.sh}
              ${builtins.readFile ./../lib-bash/snow/down.sh}
              ${builtins.readFile ./../lib-bash/snow/ps.sh}
              ${builtins.readFile ./../lib-bash/snow/run.sh}
              ${builtins.readFile ./../lib-bash/snow/switch.sh}
              ${builtins.readFile ./../lib-bash/snow/up.sh}
              ${builtins.readFile ./../lib-bash/snow/update.sh}
              # keep-sorted end

              function doHook__up__pre {
                echo -n
                ${upPreHooks}
              }

              function doHook__up__post {
                echo -n
                ${upPostHooks}
              }

              ${builtins.readFile ./../lib-bash/welcome.sh}
              ${builtins.readFile ./../lib-bash/snow/main.sh}

            '';
          };

          # we need this to remove keep sorted comments
          snowPackage = lib.sbl.strings.modifyFileContent {
            file = activationPackage;
            substitute = {
              "# keep-sorted start" = "";
              "# keep-sorted end" = "";
              "keep-sorted" = "";
            };
          };
        in {
          enable = true;
          executable = true;
          text = snowPackage;
        };
      };
    };
  });
}
