{lib, inputs, self, ...}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.lists) singleton concatLists;

  mkHomeConfiguration = {
    withSystem,
    system,
    ...
  } @ args:
    withSystem system ({
      inputs',
      self',
      pkgs,
      ...
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs self inputs' self'; };

      # Modules
      modules = concatLists [
        (singleton {


          # set baseModules in the place of nixos/lib/eval-config.nix's default argument
          # _module.args.baseModules = import "${modulesPath}/module-list.nix";
        })

        # if host needs additional modules, append them
        (args.modules or [])
      ];
    });

in {
  inherit mkHomeConfiguration;
}
