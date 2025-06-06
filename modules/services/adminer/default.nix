{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (self.utils) mkDockerService;

      cfg = config.snow-blower.services.adminer;
    in {
      options.snow-blower.services.adminer = mkDockerService {
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
        snow-blower = {
          docker-compose.services.adminer = {
            enable = true;
            service = {
              image = cfg.image;
              ports = ["${toString cfg.settings.port}:8080"];
              restart = "unless-stopped";
              environment = {
                ADMINER_DEFAULT_SERVER = cfg.settings.defaultServer;
              };
              depends_on = lib.optional config.snow-blower.services.mysql.enable "mysql";
            };
          };
        };
      };
    });
  };
}
