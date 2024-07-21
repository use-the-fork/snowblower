{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str int;

  # a utility helper to create options for Just Presets
  mkJustRecipe = {
    name,
    package,
    settings ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} just command";
    package = mkOption {
      type = lib.types.package;
      description = "The recipie ${name} should use.";
      default = package;
    };
    inherit settings ;
  };
in {
  inherit mkJustRecipe;
}
