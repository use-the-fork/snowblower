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
      inherit (self.utils) mkCodeQualityTool mkCodeQualityCommand;

      cfg = config.snowblower.codeQuality.programs.deadnix;
    in {
      options.snowblower.codeQuality.programs.deadnix = mkCodeQualityTool {
        name = "Deadnix";
        package = pkgs.deadnix;

        lint = mkCodeQualityCommand {
          enable = true;
          command = "deadnix";
          args = ["--edit"];
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
        };
      };
    });
  };
}
