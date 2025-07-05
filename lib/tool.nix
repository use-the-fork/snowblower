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

  # heavily modifed version of https://github.com/numtide/treefmt-nix/blob/main/default.nix
  # Thanks treefmt team!
  mkTool = {
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

  mkToolCommandHook = {
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

  mkToolCommand = {
    exec,
    enable ? false,
    args ? [],
    priority ? 0,
    hook ? mkToolCommandHook {},
  }: {
    enable = mkOption {
      type = lib.types.bool;
      description = "Enable ${exec}";
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
    exec = mkOption {
      type = lib.types.str;
      description = "The executable name";
      default = exec;
    };
    inherit hook;
  };
in {
  inherit mkTool mkToolCommand mkToolCommandHook;
}
