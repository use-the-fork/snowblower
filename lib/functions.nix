{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit
    (lib.types)
    oneOf
    listOf
    attrsOf
    str
    bool
    int
    float
    path
    either
    ;

  valueType = oneOf [
    bool
    int
    float
    str
    path
    (attrsOf valueType)
    (listOf valueType)
  ];

  # The `mkIntegration` function creates a standardized module for integrations
  # with consistent options and behavior. It reduces boilerplate when defining
  # new integration modules.
  mkIntegration = {
    name,
    package,
    config ? {},
    extraOptions ? {},
  }: {
    # Standard enable option for the integration
    enable = mkEnableOption "${name} integration";

    # Package option with appropriate default
    package = mkOption {
      type = lib.types.package;
      description = "The ${name} package to use.";
      default = package;
    };

    settings =
      {
        config = mkOption {
          type = valueType;
          description = "Configuration settings for ${name}.";
          default = config;
        };
      }
      // extraOptions;
  };

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

  mkPackageManager = {
    name,
    package,
    config ? {},
    extraOptions ? {},
  }: {
    enable = mkEnableOption "${name} Package Manager";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    settings =
      {
        config = mkOption {
          type = valueType;
          description = "Configuration settings for ${name}.";
          default = config;
        };
      }
      // extraOptions;
  };

  #Same as mkEnableOption but with the default set to true.
  mkEnableOption' = desc: lib.mkEnableOption "${desc}" // {default = true;};
in {
  inherit mkIntegration mkLanguage mkEnableOption' mkPackageManager;
}
