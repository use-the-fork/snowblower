{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkPackageManager;
    cfg = config.snowblower.language.php.composer;
  in {
    options.snowblower.language.php.composer = mkPackageManager {
      name = "Composer";
      package = pkgs.php83Packages.composer;
    };

    config.snowblower = lib.mkIf cfg.enable {
      # assertions = [
      #   {
      #     assertion = config.snowblower.language.php.enable;
      #     message = ''
      #       Warning: snowblower.language.php.composer.enable is true, but snowblower.language.php.enable is not.
      #       PHP language support must be enabled for Composer to function correctly within the SnowBlower environment.
      #       Please set snowblower.language.php.enable = true;
      #     '';
      #   }
      # ];

      packages.runtime = [
        cfg.package
      ];
    };
  });
}
#

