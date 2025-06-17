{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkCodeQualityTool mkCodeQualityCommand mkCodeQualityCommandHook;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.codeQuality.shfmt;
  in {
    options.snowblower.codeQuality.shfmt = mkCodeQualityTool {
      name = "shfmt";
      package = pkgs.shfmt;
      includes = [
        "*.sh"
        "*.bash"
        "*.envrc"
        "*.envrc.*"
      ];

      lint = mkCodeQualityCommand {
        enable = true;
        exec = "shfmt";
        args = [
          "-s"
          "-w"
        ];
        hook = mkCodeQualityCommandHook {};
      };
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
