{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) mkDockerService mkDockerComposeService;

    cfg = config.snowblower.service.mysql;
  in {
    options.snowblower.service.mysql = mkDockerService {
      name = "MySQL";
      image = "mysql/mysql-server:8.0";
      port = 3306;
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.common.dependsOn = ["mysql"];
        docker.service.mysql = {
          enable = true;
          service = mkDockerComposeService {
            service = {
              inherit (cfg) image;
              ports = ["\${MYSQL_FORWARD_PORT:-${toString cfg.settings.port}}:3306"];
              volumes = ["${toString config.snowblower.environmentVariables.MYSQLDATA}:/var/lib/mysql"];
              healthcheck = {
                test = ["CMD" "mysqladmin" "ping" "-p\${MYSQL_PASSWORD}"];
                interval = "10s";
                timeout = "5s";
                retries = 3;
              };
              environment = {
                MYSQL_ROOT_HOST = "%";
                MYSQL_ROOT_PASSWORD = "\${MYSQL_PASSWORD}";
                MYSQL_DATABASE = "\${MYSQL_DATABASE}";
                MYSQL_USER = "\${MYSQL_USER}";
                MYSQL_PASSWORD = "\${MYSQL_PASSWORD}";
                MYSQL_ALLOW_EMPTY_PASSWORD = 1;
              };
            };
            autoStart = true;
          };
        };

        environmentVariables.MYSQLDATA = "\${SB_PROJECT_STATE}/mysql";
      };
    };
  });
}
