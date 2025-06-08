{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];

  # https://github.com/google/keep-sorted

  flake.flakeModules.codeQuality = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (self.utils) mkCodeQualityTool mkCodeQualityCommand;

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
          packages = [
            cfg.package
          ];
        };
      };
    });
  };
}
