{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  # a utility helper to standerdize languages.
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

  # a utility helper to standerdize tools.
  mkLanguageTool = {
    name,
    package,
    settingType
  }: {
    enable = mkEnableOption "tools for ${name} development";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    settings = mkOption {
            type = settingType;
            default = { };
            description = "Specify the configuration for ${name}";
          };
  };

in {
  inherit mkLanguage mkLanguageTool;
}
