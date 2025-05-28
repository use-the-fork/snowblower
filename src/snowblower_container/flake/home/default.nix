{config, lib, ...}: let 

  inherit (lib) mkOption types;

  cfg = config.snowblower.environment;

in {
  imports = [
    ./languages
    ./shell
    ./shell-tools
    ./packages.nix
    ../configuration.nix
  ];

  options.snowblower.environment = {
    user = mkOption {
      type = types.str;
      description = "The username for configuration";
      default = "code";
    };
  };

  config = {
    programs.home-manager.enable = true;
    home = {
      username = cfg.user;
      homeDirectory = "/home/${cfg.user}";

      enableNixpkgsReleaseCheck = false;
      stateVersion = "24.05";
      sessionVariables = {};
    };
  };
}
