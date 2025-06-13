{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.codeQuality.programs.ruff;
  in {
    options.snowblower.codeQuality.programs.ruff = mkCodeQualityTool {
      name = "Ruff";
      package = pkgs.ruff;
      includes = [
        "*.py"
        "*.pyi"
      ];

      lint = mkCodeQualityCommand {
        enable = true;
        command = "ruff";
        args = ["check" "--fix"];
      };

      format = mkCodeQualityCommand {
        enable = true;
        command = "ruff";
        args = ["format"];
        priority = 100;
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = let
        finalSettings =
          cfg.settings.config
          // (
            lib.optionalAttrs (cfg.settings.includes != []) {
              include = cfg.settings.includes;
            }
            // lib.optionalAttrs (cfg.settings.excludes != []) {
              exclude = cfg.settings.excludes;
            }
          );
      in {
        dependencies.shell = [
          cfg.package
        ];

        file."ruff.toml" = {
          enable = finalSettings != {};
          settings = tomlFormat.generate "ruff.toml" finalSettings;
        };
      };
    };
  });
}
