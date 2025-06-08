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
      inherit (self.utils) mkDockerService;

      cfg = config.snowblower.services.redis;
    in {
      options.snowblower.services.redis = mkDockerService {
        name = "Redis";
        image = "redis:alpine";
        port = 6379;
        extraOptions = {};
      };

      config = lib.mkIf cfg.enable {
        snowblower = {
          docker-compose.services.redis = {
            enable = true;
            service = {
              inherit (cfg) image;
              ports = ["${toString cfg.settings.port}:6379"];
              volumes = ["${toString config.snowblower.env.REDISDATA}:/data"];
              restart = "unless-stopped";
              healthcheck = {
                test = ["CMD" "redis-cli" "ping"];
                interval = "10s";
                timeout = "5s";
                retries = 3;
              };
            };
          };

          env.REDISDATA = config.snowblower.env.PROJECT_STATE + "/redis";
        };
      };
    });
  };
}
