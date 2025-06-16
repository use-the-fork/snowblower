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

  # The `mkDockerService` function takes a few arguments to generate
  # a module for a service without repeating the same options
  # over and over: every online service needs a host and a port.
  mkDockerService = {
    name,
    image,
    port ? 0, # default port should be a stub
    extraOptions ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} docker service";
    image = mkOption {
      type = lib.types.str;
      description = "The image ${name} should use.";
      default = image;
    };
    settings =
      {
        port = mkOption {
          type = either int str;
          default = port;
          description = "The port ${name} will listen on";
          apply = value:
            if lib.isString value
            then lib.toInt value
            else value;
        };
      }
      // extraOptions;
  };

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
    settings ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} Package Manager";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    inherit settings;
  };

  # heavily modifed version of https://github.com/numtide/treefmt-nix/blob/main/default.nix
  # Thanks treefmt team!
  mkCodeQualityTool = {
    name,
    package,
    includes ? [],
    excludes ? [],
    lint ? {},
    format ? {},
    config ? {},
    extraOptions ? {},
  }: {
    enable = mkEnableOption "${name} Code Quality Tool";

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

        includes = lib.mkOption {
          description = "Path / file patterns to include";
          type = lib.types.listOf lib.types.str;
          default = includes;
        };

        excludes = lib.mkOption {
          description = "Path / file patterns to exclude";
          type = lib.types.listOf lib.types.str;
          default = excludes;
        };

        inherit lint;
        inherit format;
      }
      // extraOptions;
  };

  mkCodeQualityCommandHook = {
    enable ? true,
    args ? [],
    config ? {},
  }: {
    enable = mkOption {
      type = lib.types.bool;
      description = "Enable hook";
      default = enable;
    };
    args = mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Additional arguments to pass to the command when running as a hook";
      default = args;
    };
    config = mkOption {
      type = valueType;
      description = "Configuration settings for the local command when running inside precommit hooks.";
      default = config;
    };
  };

  mkCodeQualityCommand = {
    command,
    enable ? false,
    args ? [],
    priority ? 0,
    hook ? mkCodeQualityCommandHook {},
  }: {
    enable = mkOption {
      type = lib.types.bool;
      description = "Enable ${command}";
      default = enable;
    };
    args = mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Arguments to pass to the command";
      default = args;
    };
    priority = lib.mkOption {
      description = "Priority (used to order commands when running treefmt)";
      type = lib.types.nullOr lib.types.int;
      default = priority;
    };
    command = mkOption {
      type = lib.types.str;
      description = "The executable name";
      default = command;
    };
    inherit hook;
  };

  #Same as mkEnableOption but with the default set to true.
  mkEnableOption' = desc: lib.mkEnableOption "${desc}" // {default = true;};
in {
  inherit mkIntegration mkLanguage mkCodeQualityTool mkCodeQualityCommand mkEnableOption' mkPackageManager mkDockerService mkCodeQualityCommandHook;
}
