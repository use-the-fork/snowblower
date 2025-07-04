{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkPackageManager;
    cfg = config.snowblower.language.javascript.npm;
  in {
    options.snowblower.language.javascript.npm = mkPackageManager {
      name = "NPM";
      package = pkgs.nodejs_24;
    };

    config.snowblower = lib.mkIf cfg.enable {
      packages.runtime = [
        cfg.package
      ];

      # We swap the javascript package for the full package that includes NPM
      # even if javascript is off this will get properly merged in.
      language.javascript.package = cfg.package;

      environmentVariables = {
        NPM_CONFIG_CACHE = "\${SB_PROJECT_STATE}/npm";
        NPM_CONFIG_USERCONFIG = "\${SB_PROJECT_STATE}/npm/config";
        NPM_CONFIG_TMP = "\${SB_PROJECT_STATE}/npm";
      };

      directories = [
        "\${SB_PROJECT_STATE}/npm"
        "\${SB_PROJECT_STATE}/npm/config"
      ];
    };
  });
}
#

