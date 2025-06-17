_localFlake: {...}: {
  imports = [
    ./modules/code-quality
    ./modules/docker.nix
    ./modules/integrations
    ./modules/languages
    ./modules/services
    ./modules/command.nix
    ./modules/files.nix
    ./modules/packages.nix
    ./modules/processes.nix
    ./modules/shell.nix
    ./modules/snowblower-environment.nix
  ];
}
