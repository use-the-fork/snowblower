{flake-parts-lib, ...}: {
  # https://github.com/google/keep-sorted

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand;

    cfg = config.snowblower.codeQuality.programs.keep-sorted;
  in {
    options.snowblower.codeQuality.programs.keep-sorted = mkCodeQualityTool {
      name = "Keep-sorted";
      package = pkgs.keep-sorted;

      format = mkCodeQualityCommand {
        enable = true;
        command = "keep-sorted";
      };

      includes = [
        "*"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        dependencies.shell = [
          cfg.package
        ];
      };
    };
  });
}
