{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  commandModule = {
    imports = [./command-module.nix];
    config._module.args = {inherit pkgs;};
  };
  commandType = types.submodule commandModule;
in {
  inherit commandModule commandType;
}
