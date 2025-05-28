{
  self,
  inputs,
  lib,
  withSystem,
  ...
}:

let

  inherit (self.utils) mkHomeConfiguration;

in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake = {
    homeModules = {
      snowblower = import ./home;
    };
    homeConfigurations = {
      snowblower = mkHomeConfiguration {
        inherit withSystem;
        system = "x86_64-linux";
        modules = [
          self.homeModules.snowblower
        ];
      };
    };
    homeManagerModules = lib.warn "`homeManagerModules` is deprecated. Use `homeModules` instead." self.homeModules;
  };
}