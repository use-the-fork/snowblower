{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;
    jsonFormat = pkgs.formats.json {};

    cfg = config.snowblower.codeQuality.programs.biome;
  in {
    options.snowblower.codeQuality.programs.biome = mkCodeQualityTool {
      name = "Biome";
      package = pkgs.biome;
      includes = [
        "*.js"
        "*.ts"
        "*.mjs"
        "*.mts"
        "*.cjs"
        "*.cts"
        "*.jsx"
        "*.tsx"
        "*.d.ts"
        "*.d.cts"
        "*.d.mts"
        "*.json"
        "*.jsonc"
        "*.css"
      ];

      config = {
        "$schema" = "https://biomejs.dev/schemas/1.9.4/schema.json";
      };

      lint = mkCodeQualityCommand {
        enable = true;
        command = "biome";
        args = ["lint" "--write"];
      };

      format = mkCodeQualityCommand {
        enable = true;
        command = "biome";
        args = ["format" "--write"];
        priority = 100;
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = let
        finalSettings =
          cfg.settings.config
          // (
            lib.optionalAttrs (cfg.settings.includes != []) {
              files.include = cfg.settings.includes;
            }
            // lib.optionalAttrs (cfg.settings.excludes != []) {
              files.ignore = cfg.settings.excludes;
            }
            // lib.optionalAttrs (cfg.settings.lint.enable or false) {
              linter.enabled = true;
            }
            // lib.optionalAttrs (cfg.settings.format.enable or false) {
              formatter.enabled = true;
            }
          );
      in {
        dependencies.shell = [
          cfg.package
        ];

        file."biome.json" = {
          enable = true;
          settings = jsonFormat.generate "biome.json" finalSettings;
        };
      };
    };
  });
}
