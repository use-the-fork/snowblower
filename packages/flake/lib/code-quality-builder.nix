{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;

  # modifed version of https://github.com/numtide/treefmt-nix/blob/main/default.nix
  # Thanks treefmt team!
  mkCodeQualityTool = {
    name,
    package,
    includes ? [],
    excludes ? [],
    argsLint ? [],
    argsFormat ? [],
    programName ? name,
    configuration ? {},
    format ? pkgs.formats.yaml {},
    extraOptions ? {},
  }: {
    enable = mkEnableOption "${name} Linter";

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
          default = programName;
        };

        args = {
          lint = mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Arguments to pass to ${name} when linting";
            default = argsLint;
          };

          format = mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Arguments to pass to ${name} when formatting";
            default = argsFormat;
          };
        };
      }
      // extraOptions;
  };
in {
  inherit mkCodeQualityTool;
}
