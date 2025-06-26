{flake-parts-lib, ...}: {
  # https://github.com/google/keep-sorted

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;

    cfg = config.snowblower.tool.keepSorted;
  in {
    options.snowblower.tool.keepSorted = mkTool {
      name = "Keep-sorted";
      package = pkgs.keep-sorted;

      format = mkToolCommand {
        enable = true;
        exec = "keep-sorted";
      };
      excludes = [
        ".snowblower/*"
      ];
      includes = [
        "*"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        packages.tools = [
          cfg.package
        ];
      };
    };
  });
}
