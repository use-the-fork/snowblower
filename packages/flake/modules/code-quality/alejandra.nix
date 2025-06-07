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

      cfg = config.snow-blower.codeQuality.alejandra;
    in {
      options.snow-blower.codeQuality.alejandra = mkCodeQualityTool {
        name = "Alejandra";
        package = pkgs.alejandra;
        formatEnable = true;
        format = tomlFormat;
        includes = [
          "*.nix"
        ];
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          wrapper = mkConfigFile {
            name = "alejandra.toml";
            format = tomlFormat;
            settings = cfg.settings.configuration;
          };
        };
      };
    });
  };
}
