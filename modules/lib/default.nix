{
  inputs,
  flake-parts-lib,
  lib,
  ...
}: let
  sb = {
    mkAi = import ./modules/mkAi.nix {inherit lib;};
    mkService = import ./modules/mkService.nix {inherit lib;};
    mkIntegration = import ./modules/mkIntegration.nix {inherit lib;};
    mkEnableOption' = import ./mkEnableOption.nix {inherit lib;};
    mkCmdArgs = import ./mkCmdArgs.nix {inherit lib;};
  };
in {
  # I personally HATE this abstraction. But I could not for the life of me
  # figure out a better way to do this. if you happend to be looking at this
  # and know how please
  flake.flakeModules.lib = {
    options.flake = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [
          {
            options.lib.mkFlake = lib.mkOption {
              type = lib.types.functionTo (lib.types.functionTo (lib.types.attrsOf lib.types.anything));
              default = args:
                flake-parts-lib.mkFlake (
                  lib.recursiveUpdate {inherit inputs;} args
                );
            };
          }
        ];
      };
    };

    config.flake.lib = {
      inherit sb;
    };
  };
}
