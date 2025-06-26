{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.ruff;
  in {
    options.snowblower.tool.ruff = mkTool {
      name = "Ruff";
      package = pkgs.ruff;
      includes = [
        "*.py"
        "*.pyi"
      ];

      lint = mkToolCommand {
        enable = true;
        exec = "ruff";
        args = ["check" "--fix"];
      };

      format = mkToolCommand {
        enable = true;
        exec = "ruff";
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
        packages.tools = [
          cfg.package
        ];

        file."ruff.toml" = {
          enable = finalSettings != {};
          source = tomlFormat.generate "ruff.toml" finalSettings;
        };
      };
    };
  });
}
