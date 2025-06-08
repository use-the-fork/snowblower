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

      cfg = config.snowblower.codeQuality.programs.mdformat;
    in {
      options.snowblower.codeQuality.programs.mdformat = mkCodeQualityTool {
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
          packages = [
            cfg.package
          ];

          core = mkConfigFile {
            name = ".mdformat.toml";
            format = tomlFormat;
            settings = finalSettings;
          };
        };
      };
    });
  };
}
