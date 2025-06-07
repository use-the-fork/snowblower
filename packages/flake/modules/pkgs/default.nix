{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # To use these within the flake use
    # self'.packages.

    overlayAttrs = config.packages;
    packages = lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./packages;
    };
  };
}
