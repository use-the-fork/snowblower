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

    drvOrPackageToPaths = drvOrPackage:
      if drvOrPackage ? outputs
      then builtins.map (output: drvOrPackage.${output}) drvOrPackage.outputs
      else [drvOrPackage];
  in {
    options.snowblower = {
      dependencies = {
        shell = mkOption {
          type = listOf types.package;
          internal = true;
          description = "Packages to install in the development shell environment";
          default = [];
        };

        docker = mkOption {
          type = listOf types.package;
          internal = true;
          description = "Packages to install in Docker containers";
          default = [];
        };

        common = mkOption {
          type = listOf types.package;
          internal = true;
          description = "Packages to install in both development shell and Docker containers";
          default = [];
        };
      };

      packages = {
        shell = mkOption {
          type = types.package;
          internal = true;
          description = "Combined package containing all shell environment dependencies";
        };

        docker = mkOption {
          type = types.package;
          internal = true;
          description = "Combined package containing all Docker container dependencies";
        };
      };
    };

    config = {
      snowblower.packages.shell = pkgs.mkShell {
        name = "snowblower";
        packages = config.snowblower.dependencies.shell ++ config.snowblower.dependencies.common;
        # shellHook = ''
        #   ${setupShell}
        # '';
      };

      snowblower.packages.docker = pkgs.buildEnv {
        name = "snowblower-docker";
        paths = lib.flatten (builtins.map drvOrPackageToPaths (config.snowblower.dependencies.docker ++ config.snowblower.dependencies.common));
        ignoreCollisions = true;
      };

      devShells.default = config.snowblower.packages.shell;
      packages = {
        snowblowerDevShell = config.snowblower.packages.shell;
        snowblowerDocker = config.snowblower.packages.docker;
      };
    };
  });
}
