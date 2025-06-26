{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;

    cfg = config.snowblower.tool.deadnix;
  in {
    options.snowblower.tool.deadnix = mkTool {
      name = "Deadnix";
      package = pkgs.deadnix;

      lint = mkToolCommand {
        enable = true;
        exec = "deadnix";
        args = ["--edit"];
      };

      includes = [
        "*.nix"
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
