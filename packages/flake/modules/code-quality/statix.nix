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

      cfg = config.snow-blower.codeQuality.statix;
    in {
      options.snow-blower.codeQuality.statix = mkCodeQualityTool {
        name = "Statix";
        package = pkgs.statix;

        lint = mkCodeQualityCommand {
          enable = true;
          command = "statix-fix";
        };

        configFormat = tomlFormat;
        includes = [
          "*.nix"
        ];
      };

      config = lib.mkIf cfg.enable {
        snow-blower = let
          # from https://github.com/numtide/treefmt-nix/blob/main/programs/statix.nix
          # Thanks again treefmt :)
          multipleTargetsCommand = pkgs.writeShellScriptBin "statix-fix" ''
            for file in "$@"; do
              statix fix "$file"
            done
          '';
        in {
          packages = [
            cfg.package
            multipleTargetsCommand
          ];

          wrapper = mkConfigFile {
            name = "statix.toml";
            format = tomlFormat;
            settings = cfg.settings.config;
          };
        };
      };
    });
  };
}
