_localFlake: {...}: {
  imports = [
    ./modules/code-quality
    ./modules/docker.nix
    ./modules/integrations
    ./modules/languages
    ./modules/command.nix
    ./modules/files.nix
    ./modules/packages.nix
    ./modules/snowblower-environment.nix
  ];
}
