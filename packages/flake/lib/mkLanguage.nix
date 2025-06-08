{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  # a utility helper to standerdize integrations.
  mkLanguage = {
    name,
    package,
    settings ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "tools for ${name} development";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    inherit settings;
  };
in {
  inherit mkLanguage;
}
