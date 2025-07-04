{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkPackageManager;

    tomlFormat = pkgs.formats.toml {};
    cfg = config.snowblower.language.python.uv;
  in {
    options.snowblower.language.python.uv = mkPackageManager {
      name = "UV";
      package = pkgs.uv;
    };

    config.snowblower = lib.mkIf cfg.enable {
      packages.runtime = [
        cfg.package
      ];

      file."uv.toml" = {
        enable = true;
        source = tomlFormat.generate "uv.toml" cfg.settings.config;
      };

      environmentVariables = {
        UV_CACHE_DIR = "\${SB_PROJECT_STATE}/uv/cache";
      };

      directories = [
        "\${SB_PROJECT_STATE}/uv"
        "\${SB_PROJECT_STATE}/uv/cache"
      ];
    };
  });
}
