{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption mkDockerImage;

    yamlFormat = pkgs.formats.yaml {};
  in {
    options.snowblower = {
      docker = {
        image = {
          runtimePackage = mkOption {
            internal = true;
            type = types.package;
            description = "The package containing the environment docker uses.";
          };
          toolsPackage = mkOption {
            internal = true;
            type = types.package;
            description = "The package containing the environment docker uses.";
          };
        };
      };
    };

    config = {
      snowblower = {
        docker = {
          image = {
            runtimePackage = mkDockerImage pkgs {
              name = "runtime";
              basePackageSet = "micro";
              packages = config.snowblower.packages.runtime;
            };
            toolsPackage = mkDockerImage pkgs {
              name = "tools";
              fromImage = config.snowblower.docker.image.runtimePackage;
              packages = config.snowblower.packages.tools;
            };
          };
        };
      };

      packages = {
        dockerRuntimeImagePackage = config.snowblower.docker.image.runtimePackage;
        dockerToolsImagePackage = config.snowblower.docker.image.toolsPackage;
      };
    };
  });
}
