{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./composer.nix
  ];
}
