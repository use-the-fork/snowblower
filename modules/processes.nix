{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption mkDockerComposeRuntimeService;

    cfg = lib.filterAttrs (_n: f: f.enable) config.snowblower.process;

    processModule = {
      imports = [./../lib/types/process-module.nix];
      config._module.args = {inherit pkgs;};
    };
    processType = types.submodule processModule;
  in {
    imports = [
      {
        options.snowblower.process = mkOption {
          type = types.submoduleWith {
            modules = [{freeformType = types.attrsOf processType;}];
            specialArgs = {inherit pkgs;};
          };
          default = {};
          description = ''
            The processes that run via docker-compose and SnowBlower
          '';
        };
      }
    ];

    config = {
      snowblower.packages.runtime =
        lib.mapAttrsToList (
          name: process:
            pkgs.writeShellScriptBin "snowblower-process-${name}" process.exec
        )
        cfg;
      snowblower.docker.service =
        lib.mapAttrs (name: process: {
          enable = true;
          service = mkDockerComposeRuntimeService {
            image = "${config.snowblower.docker.image.runtimePackage.imageName}:${config.snowblower.docker.image.runtimePackage.imageTag}";
            service = {
              ports =
                lib.optional (process.port.container != null && process.port.host != null)
                "${toString process.port.host}:${toString process.port.container}";
              command = "with-snowblower snowblower-process-${name}";
            };
          };
        })
        cfg;
    };
  });
}
