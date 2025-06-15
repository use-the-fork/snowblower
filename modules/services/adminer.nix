{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption mkDockerService;

    cfg = config.snowblower.service.adminer;
  in {
    options.snowblower.service.adminer = mkDockerService {
      name = "Adminer";
      image = "adminer:latest";
      port = 8080;
      extraOptions = {
        defaultServer = lib.mkOption {
          type = types.str;
          default = "mysql";
          description = ''
            Default database server type (mysql, pgsql, etc).
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.services.adminer = {
          enable = true;
          service = {
            inherit (cfg) image;
            ports = ["${toString cfg.settings.port}:8080"];
            restart = "unless-stopped";
            environment = {
              ADMINER_DEFAULT_SERVER = cfg.settings.defaultServer;
            };
            depends_on = lib.optional config.snowblower.service.mysql.enable "mysql";
          };
        };
      };
    };
  });
}
