{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  serviceModule = {
    imports = [./service-module.nix];
    config._module.args = {inherit pkgs;};
  };
  serviceType = types.submodule serviceModule;
in {
  inherit serviceModule serviceType;
}
