{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;

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
    configFormat ? pkgs.formats.yaml {},
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
          type = configFormat.type;
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

  mkCodeQualityCommand = {
    command,
    enable ? false,
    args ? [],
    priority ? 0,
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
  };
in {
  inherit mkCodeQualityTool mkCodeQualityCommand;
}
