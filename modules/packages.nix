{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.types) listOf;
  in {
    options.snowblower = {
      packages = {
        runtime = mkOption {
          type = listOf types.package;
          description = "Packages to install in the snowblower environment";
          default = [];
        };

        tools = mkOption {
          type = listOf types.package;
          description = "Packages to install in the snowblower environment";
          default = [];
        };
      };
    };

    config = {
      snowblower = {
      };
    };
  });
}
