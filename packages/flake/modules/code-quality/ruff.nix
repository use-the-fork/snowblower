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
      inherit (self.utils) mkCodeQualityTool mkConfigFile;
      tomlFormat = pkgs.formats.toml {};

      cfg = config.snow-blower.codeQuality.ruff;
    in {
      options.snow-blower.codeQuality.ruff = mkCodeQualityTool {
        name = "Ruff";
        package = pkgs.ruff;
        format = tomlFormat;
        includes = [
          "*.py"
          "*.pyi"
        ];
        formatEnable = true;
        formatArgs = ["format"];

        lintEnable = true;
        lintArgs = ["check" "--fix"];
      };

      config = lib.mkIf cfg.enable {
        snow-blower = let
          finalSettings =
            cfg.settings.configuration
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
