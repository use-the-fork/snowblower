{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.sqlfluff;
  in {
    options.snowblower.tool.sqlfluff = mkTool {
      name = "SQLFluff";
      package = pkgs.sqlfluff;
      includes = [
        "*.sql"
      ];

      lint = mkToolCommand {
        enable = true;
        exec = "ruff";
        args = ["fix" "--force"];
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = let
        finalSettings =
          lib.recursiveUpdate
          cfg.settings.config
          (lib.optionalAttrs (cfg.settings.includes != []) {
            sqlfluff.sql_file_exts = cfg.settings.includes;
          });
      in {
        packages.tools = [
          cfg.package
        ];

        file.".sqlfluff" = {
          enable = finalSettings != {};
          source = tomlFormat.generate ".sqlfluff" finalSettings;
        };
      };
    };
  });
}
