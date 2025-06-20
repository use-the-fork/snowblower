{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.types) listOf;
  in {
    options.snowblower = {
      packages = mkOption {
        type = listOf types.package;
        description = "Packages to install in the snowblower environment";
        default = [];
      };
    };

    config = {
      snowblower = {
      };
    };
  });
}
