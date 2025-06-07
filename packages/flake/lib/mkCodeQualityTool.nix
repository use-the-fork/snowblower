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
    lintEnable ? false,
    lintArgs ? [],
    lintPriority ? 0,
    formatEnable ? false,
    formatArgs ? [],
    formatPriority ? 100,
    programName ? name,
    configuration ? {},
    format ? pkgs.formats.yaml {},
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
        configuration = mkOption {
          type = format.type;
          description = "Configuration settings for ${name}.";
          default = configuration;
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

        program = mkOption {
          type = lib.types.str;
          description = "The main executable name for ${name}";
          default = lib.toLower programName;
        };

        lint = {
          enable = mkOption {
            type = lib.types.bool;
            description = "Enable linting with ${name}";
            default = lintEnable;
          };
          args = mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Arguments to pass to ${name} when linting";
            default = lintArgs;
          };
          priority = lib.mkOption {
            description = "Priority";
            type = lib.types.nullOr lib.types.int;
            default = lintPriority;
          };
        };

        format = {
          enable = mkOption {
            type = lib.types.bool;
            description = "Enable formatting with ${name}";
            default = formatEnable;
          };
          args = mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Arguments to pass to ${name} when formatting";
            default = formatArgs;
          };
          priority = lib.mkOption {
            description = "Priority (used to order commands when running treefmt)";
            type = lib.types.nullOr lib.types.int;
            default = formatPriority;
          };
        };
      }
      // extraOptions;
  };
in {
  inherit mkCodeQualityTool;
}
