{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  imports = [
    ./compose.nix
    ./image.nix
  ];
}
