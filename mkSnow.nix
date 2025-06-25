{
  inputs,
  self,
  lib,
  ...
}: userConfigFn:
inputs.flake-parts.lib.mkFlake {
  inherit inputs;
  specialArgs = {inherit lib;};
} ({...}: {
  systems = import inputs.systems;
  imports = [
    self.flakeModules.default
  ];
  perSystem = userConfigFn;
})
