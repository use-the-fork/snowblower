{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  featureModule = {
    imports = [./feature-module.nix];
    config._module.args = {inherit pkgs;};
  };
  featureType = types.submodule featureModule;

  mkCmdArgs = predActionList:
    lib.concatStringsSep
    " "
    (builtins.foldl'
      (acc: entry:
        acc ++ lib.optional (builtins.elemAt entry 0) (builtins.elemAt entry 1))
      []
      predActionList);
in {
  inherit mkCmdArgs featureModule featureType;
}
