{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./ruff.nix
    ./uv.nix
  ];
}
