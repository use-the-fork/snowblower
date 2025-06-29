{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.sbl.docker) mkDockerService mkCommonFlags;

    cfg = config.snowblower.service.redis;
  in {
    options.snowblower.service.redis = mkDockerService {
      name = "Redis";
      image = "redis:alpine";
      port = 6379;
      extraOptions = {};
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.common.dependsOn = ["redis"];
        docker.service.redis = {
          enable = true;
          service = {
            inherit (cfg) image;
            ports = ["${toString cfg.settings.port}:6379"];
            volumes = ["${toString config.snowblower.environmentVariables.REDISDATA}:/data"];
            restart = "no";
            "sb-common" = mkCommonFlags {autoStart = true;};
            healthcheck = {
              test = ["CMD" "redis-cli" "ping"];
              interval = "10s";
              timeout = "5s";
              retries = 3;
            };
          };
        };

        environmentVariables.REDISDATA = "\${SB_PROJECT_STATE}/redis";
      };
    };
  });
}
