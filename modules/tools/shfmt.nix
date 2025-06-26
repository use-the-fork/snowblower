{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand mkToolCommandHook;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.shfmt;
  in {
    options.snowblower.tool.shfmt = mkTool {
      name = "shfmt";
      package = pkgs.shfmt;
      includes = [
        "*.sh"
        "*.bash"
        "*.envrc"
        "*.envrc.*"
      ];

      lint = mkToolCommand {
        enable = true;
        exec = "shfmt";
        args = [
          "-s"
          "-w"
        ];
        hook = mkToolCommandHook {};
      };
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
