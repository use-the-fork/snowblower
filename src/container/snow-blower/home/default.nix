{config, ...}: {
  imports = [
    ./languages
    ./shell
    ./tools
    ./packages.nix
    ../snow-blower-config.nix
  ];

  config = {
    programs.home-manager.enable = true;
    home = {
      enableNixpkgsReleaseCheck = false;
      stateVersion = "24.05";
      sessionVariables = {};
    };
  };
}
