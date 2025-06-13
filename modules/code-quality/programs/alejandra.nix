{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.codeQuality.programs.alejandra;
  in {
    options.snowblower.codeQuality.programs.alejandra = mkCodeQualityTool {
      name = "Alejandra";
      package = pkgs.alejandra;

      lint = mkCodeQualityCommand {
        enable = true;
        command = "alejandra";
      };

      includes = [
        "*.nix"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        dependencies.shell = [
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
