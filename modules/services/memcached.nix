{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib) mkDockerService mkDockerComposeService;

    cfg = config.snowblower.service.memcached;
  in {
    options.snowblower.service.memcached = mkDockerService {
      name = "Memcached";
      image = "memcached:alpine";
      port = 11211;
      extraOptions = {
        memoryLimit = lib.mkOption {
          type = types.str;
          default = "64";
          example = "100";
          description = ''
            Memory limit for Memcached in megabytes.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.common.dependsOn = ["memcached"];
        docker.service.memcached = {
          enable = true;
          service = mkDockerComposeService {
            service = {
              inherit (cfg) image;
              ports = ["\${MEMCACHED_FORWARD_PORT:-${toString cfg.settings.port}}:11211"];
              command = ["-m" "${cfg.settings.memoryLimit}"];
              healthcheck = {
                test = ["CMD" "nc" "-z" "localhost" "11211"];
                interval = "10s";
                timeout = "5s";
                retries = 3;
              };
            };
            autoStart = true;
          };
        };
      };
    };
  });
}
