_localFlake: {...}: {
  imports = [
    # keep-sorted start
    ./modules/docker
    ./modules/environment-variables.nix
    ./modules/files.nix
    ./modules/hooks.nix
    ./modules/integrations
    ./modules/languages
    ./modules/packages.nix
    ./modules/processes.nix
    ./modules/services
    ./modules/shell.nix
    ./modules/snow.nix
    ./modules/tools
    # keep-sorted end
  ];
}
