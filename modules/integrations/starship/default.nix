{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption mkIf;
      inherit (import ../utils.nix {inherit lib;}) mkIntegration;

      cfg = config.snow-blower.integrations.starship;
    in {
      options.snow-blower.integrations.starship = mkIntegration {
        name = "Starship";
        package = pkgs.starship;
        settings = {

        };
      };

      config.snow-blower = mkIf cfg.enable {
        packages = [
          cfg.package
        ];

        # env.STARSHIP_CONFIG = config.snow-blower.env.PROJECT_STATE + "/elasticsearch";
        env.STARSHIP_CONFIG = "/workspace/starship.toml";


      shell = let
            installationScript = ''
              eval "$(starship init zsh)"  
            '';
      in {

        startup = lib.mkBefore [installationScript];
      };

      };
    });
  };
}
