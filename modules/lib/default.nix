{
  inputs,
  flake-parts-lib,
  lib,
  ...
}: let
  mkService = import ./modules/mkService.nix {inherit lib;};
  mkJustRecipe = import ./modules/mkJustRecipe.nix {inherit lib;};

  sb = {
    inherit (mkService) mkService;
    inherit (mkJustRecipe) mkJustRecipe;
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
