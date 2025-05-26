{
  config,
  lib,
  inputs,
  self,
  ...
}: {
  perSystem = {
    inputs',
    self',
    pkgs,
    ...
  }: let
    user = config.modules.user;
  in {
    legacyPackages = {
      homeConfigurations = {
        "${user.username}" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home = {
                username = "${user.username}";
                homeDirectory = "/home/${user.username}";
              };
            }
            ./home
          ];

          extraSpecialArgs = {
            # Inject inputs to use them in global registry
            inherit inputs self inputs' self';
          };
        };
      };
    };
  };
}
