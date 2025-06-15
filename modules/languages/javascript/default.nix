{flake-parts-lib, ...}: {
  imports = [
    ./npm.nix
  ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkLanguage;
    cfg = config.snowblower.languages.javascript;
  in {
    options.snowblower.languages.javascript = mkLanguage {
      name = "Javascript";
      package = pkgs.nodejs-slim;
    };

    config.snowblower = lib.mkIf cfg.enable {
      packages = [
        cfg.package
      ];
    };
  });
}
# mkPackageManager

