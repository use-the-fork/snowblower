{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.mdformat;
  in {
    options.snowblower.tool.mdformat = mkTool {
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

      format = mkToolCommand {
        enable = true;
        exec = "mdformat";
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
        packages.tools = [
          cfg.package
        ];

        file.".mdformat.toml" = {
          enable = finalSettings != {};
          source = tomlFormat.generate ".mdformat.toml" finalSettings;
        };
      };
    };
  });
}
