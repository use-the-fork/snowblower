{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand mkCodeQualityCommandHook;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.codeQuality.alejandra;
  in {
    options.snowblower.codeQuality.alejandra = mkCodeQualityTool {
      name = "Alejandra";
      package = pkgs.alejandra;

      lint = mkCodeQualityCommand {
        enable = true;
        command = "alejandra";
        hook = mkCodeQualityCommandHook {};
      };

      includes = [
        "*.nix"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        packages = [
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
