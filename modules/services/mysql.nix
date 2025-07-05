{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib) mkDockerService mkDockerComposeService;

    cfg = config.snowblower.service.mysql;
  in {
    options.snowblower.service.mysql = mkDockerService {
      name = "MySQL";
      image = "mysql:8";
      port = 3306;
      extraOptions = {
        rootPassword = lib.mkOption {
          type = types.str;
          default = "root";
          description = ''
            Root password for MySQL.
          '';
        };

        database = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Name of the initial database to create.
          '';
        };

        user = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Username to create with access to the initial database.
          '';
        };

        password = lib.mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Password for the created user.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.common.dependsOn = ["mysql"];
        docker.service.mysql = {
          enable = true;
          service = mkDockerComposeService {
            service = {
              inherit (cfg) image;
              ports = ["${toString cfg.settings.port}:3306"];
              volumes = ["${toString config.snowblower.environmentVariables.MYSQLDATA}:/var/lib/mysql"];
              environment =
                {
                  MYSQL_ROOT_PASSWORD = "\${MYSQL_ROOT_PASSWORD:-${cfg.settings.rootPassword}}";
                }
                // lib.optionalAttrs (cfg.settings.database != null) {
                  MYSQL_DATABASE = "\${MYSQL_DATABASE:-${cfg.settings.database}}";
                }
                // lib.optionalAttrs (cfg.settings.user != null) {
                  MYSQL_USER = "\${MYSQL_USER:-${cfg.settings.user}}";
                }
                // lib.optionalAttrs (cfg.settings.password != null) {
                  MYSQL_PASSWORD = "\${MYSQL_PASSWORD:-${cfg.settings.password}}";
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
