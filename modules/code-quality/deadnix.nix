{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;

    cfg = config.snowblower.codeQuality.deadnix;
  in {
    options.snowblower.codeQuality.deadnix = mkCodeQualityTool {
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
}
