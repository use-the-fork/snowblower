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
          packages = [
            cfg.package
          ];

          core = mkConfigFile {
            name = "alejandra.toml";
            format = tomlFormat;
            settings = cfg.settings.config;
          };
        };
      };
    });
  };
}
