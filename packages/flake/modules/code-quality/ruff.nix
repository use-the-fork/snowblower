{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.codeQuality = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (self.utils) mkCodeQualityTool mkConfigFile mkCodeQualityCommand;
      tomlFormat = pkgs.formats.toml {};

      cfg = config.snow-blower.codeQuality.ruff;
    in {
      options.snow-blower.codeQuality.ruff = mkCodeQualityTool {
        name = "Ruff";
        package = pkgs.ruff;
        configFormat = tomlFormat;
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
        snow-blower = let
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
          packages = [
            cfg.package
          ];

          wrapper = mkConfigFile {
            name = "ruff.toml";
            format = tomlFormat;
            settings = finalSettings;
          };
        };
      };
    });
  };
}
