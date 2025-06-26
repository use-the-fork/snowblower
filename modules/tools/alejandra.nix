{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand mkToolCommandHook;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.alejandra;
  in {
    options.snowblower.tool.alejandra = mkTool {
      name = "Alejandra";
      package = pkgs.alejandra;

      lint = mkToolCommand {
        enable = true;
        exec = "alejandra";
        hook = mkToolCommandHook {};
      };

      includes = [
        "*.nix"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        packages.tools = [
          cfg.package
        ];

        file."alejandra.toml" = {
          enable = cfg.settings.config != {};
          source = tomlFormat.generate "alejandra.toml" cfg.settings.config;
        };
      };
    };
  });
}
