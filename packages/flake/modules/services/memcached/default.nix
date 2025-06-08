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

      cfg = config.snowblower.services.memcached;
    in {
      options.snowblower.services.memcached = mkDockerService {
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
          docker-compose.services.memcached = {
            enable = true;
            service = {
              inherit (cfg) image;
              ports = ["${toString cfg.settings.port}:11211"];
              command = ["-m" "${cfg.settings.memoryLimit}"];
              restart = "unless-stopped";
              healthcheck = {
                test = ["CMD" "nc" "-z" "localhost" "11211"];
                interval = "10s";
                timeout = "5s";
                retries = 3;
              };
            };
          };
        };
      };
    });
  };
}
