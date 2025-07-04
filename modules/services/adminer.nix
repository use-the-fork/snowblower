{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.sbl.docker) mkDockerService mkDockerComposeService;

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
        docker.service.adminer = {
          enable = true;
          service = mkDockerComposeService {
            service = {
              inherit (cfg) image;
              ports = ["\${ADMINER_FORWARD_PORT:-${toString cfg.settings.port}}:8080"];
              environment = {
                ADMINER_DEFAULT_SERVER = cfg.settings.defaultServer;
              };
              depends_on = lib.optional config.snowblower.service.mysql.enable "mysql";
            };
            autoStart = true;
          };
        };
      };
    };
  });
}
