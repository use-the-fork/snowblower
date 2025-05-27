{config, ...}: {
  imports = [
    ./languages
    ./shell
    ./shell-tools
    ./packages.nix
    ../configuration.nix
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
