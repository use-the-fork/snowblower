{flake-parts-lib, ...}: {
  # https://github.com/google/keep-sorted

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;

    cfg = config.snowblower.codeQuality.keep-sorted;
  in {
    options.snowblower.codeQuality.keep-sorted = mkCodeQualityTool {
      name = "Keep-sorted";
      package = pkgs.keep-sorted;

      format = mkCodeQualityCommand {
        enable = true;
        exec = "keep-sorted";
      };

      includes = [
        "*"
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
