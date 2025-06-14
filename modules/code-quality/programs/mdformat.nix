{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.codeQuality.mdformat;
  in {
    options.snowblower.codeQuality.mdformat = mkCodeQualityTool {
      name = "mdformat";
      package = pkgs.mdformat;
      includes = [
        "*.md"
      ];

      config = {
        wrap = "keep"; # options: {"keep", "no", INTEGER}
        number = false; # options: {false, true}
        end_of_line = "lf"; # options: {"lf", "crlf", "keep"}
        validate = true; # options: {false, true}
      };

      format = mkCodeQualityCommand {
        enable = true;
        command = "mdformat";
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

        file.".mdformat.toml" = {
          enable = finalSettings != {};
          settings = tomlFormat.generate ".mdformat.toml" finalSettings;
        };
      };
    };
  });
}
