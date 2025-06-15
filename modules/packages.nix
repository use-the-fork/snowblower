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
            export IS_NIX_SHELL="1"
          '';
        };

        dockerPackage = pkgs.buildEnv {
          name = "snowblower-docker";
          paths = lib.flatten (builtins.map drvOrPackageToPaths config.snowblower.packages);
          ignoreCollisions = true;
        };
      };

      devShells.default = config.snowblower.devShellPackage;
      packages = {
        snowblowerDevShell = config.snowblower.devShellPackage;
        snowblowerDocker = config.snowblower.dockerPackage;
      };
    };
  });
}
