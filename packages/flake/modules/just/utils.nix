{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  recipeModule = {
    imports = [./recipe-module.nix];
    config._module.args = {inherit pkgs;};
  };
  recipeType = types.submodule recipeModule;
in {
  inherit recipeModule recipeType;
}
