_localFlake: {...}: {
  imports = [
    # keep-sorted start
    ./modules/code-quality
    ./modules/command.nix
    ./modules/docker.nix
    ./modules/files.nix
    ./modules/hooks.nix
    ./modules/integrations
    ./modules/languages
    ./modules/packages.nix
    ./modules/processes.nix
    ./modules/services
    ./modules/shell.nix
    ./modules/snowblower-environment.nix
    # keep-sorted end
  ];
}
