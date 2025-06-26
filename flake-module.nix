_localFlake: {...}: {
  imports = [
    # keep-sorted start
    ./modules/command.nix
    ./modules/docker
    ./modules/files.nix
    ./modules/hooks.nix
    ./modules/integrations
    ./modules/languages
    ./modules/packages.nix
    ./modules/processes.nix
    ./modules/services
    ./modules/shell.nix
    ./modules/snowblower-environment.nix
    ./modules/tools
    # keep-sorted end
  ];
}
