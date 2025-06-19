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
    inherit (lib.types) listOf;
  in {
    options.snowblower = {
      dockerPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the complete activation script.";
      };

      packages = mkOption {
        type = listOf types.package;
        description = "Packages to install in the development shell environment";
        default = [];
      };
    };

    config = {
      snowblower = {
        # From: https://github.com/diamondburned/gotk4/blob/4/flake.nix
        # A intresting way of building a dev shell where it's created using an init of our flakes dev shell and
        # then output to `~/nix-environment'` from which we can then source it when we `exec` (Default entrypoint)
        # To help with docker-compose skipping the entrypoint we also inject `with-nix` that will source our `~/nix-environment`
        dockerPackage = pkgs.buildEnv {
          name = "snowblower-docker-env";
          paths = with pkgs; [
            stdenv.cc
            stdenv.shellPackage
            (pkgs.writeShellScriptBin "docker-entrypoint" ''
              set -e

              cmd=$1
              shift

              case "$cmd" in
              "init")
                cd /workspace && ${pkgs.nix}/bin/nix develop . --command bash -c 'declare -xp > ~/nix-environment'
                ;;
              "exec")
                __user=$USER
                __home=$HOME
                __user_uid=$USER_UID

                source ~/nix-environment

                if [ ! -z "$__user_uid" ]; then
                    usermod -u $__user_uid snowblower
                fi

                USER=$__user
                HOME=$__home

                exec "$@"
                ;;
              esac
            '')
          ];
        };
      };

      packages = {
        inherit (config.snowblower) dockerPackage;
      };
    };
  });
}
