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

      devShellPackage = mkOption {
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
        devShellPackage = pkgs.mkShell {
          name = "snowblower";
          packages = config.snowblower.packages;
          shellHook = ''
          '';
        };

        dockerPackage = pkgs.buildEnv {
          name = "snowblower-docker-env";
          paths = with pkgs;
            [
              stdenv.cc
              stdenv.shellPackage
              (pkgs.writeShellScriptBin "docker-entrypoint" ''
                set -e

                cmd=$1
                shift

                case "$cmd" in
                "init")
                  ${pkgs.nix}/bin/nix-shell --pure --run 'declare -xp > /nix-environment'
                  ;;
                "exec")
                  __user=$USER
                  __home=$HOME

                  source /nix-environment

                  USER=$__user
                  HOME=$__home

                  eval "$@"
                  ;;
                esac
              '')
            ]
            ++ config.snowblower.packages;
        };
      };

      devShells.default = config.snowblower.devShellPackage;
      packages = {
        snowblowerDevShell = config.snowblower.devShellPackage;
        dockerPackage = config.snowblower.dockerPackage;
      };
    };
  });
}
