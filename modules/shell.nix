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
      devShellPackage = mkOption {
        internal = true;
        type = types.package;
        description = "The package containing the complete activation script.";
      };
    };

    config = {
      snowblower = {
      };

      packages = {
        # snowblowerDevShell = config.snowblower.devShellPackage;
      };
    };
  });
}
