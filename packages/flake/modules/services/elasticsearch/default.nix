{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./kibana.nix
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (self.utils) mkDockerService;

      cfg = config.snowblower.services.elasticsearch;
    in {
      options.snowblower.services.elasticsearch = mkDockerService {
        name = "Elasticsearch";
        image = "elasticsearch:8.12.0";
        port = 9200;
        extraOptions = {
          tcpPort = lib.mkOption {
            type = types.int;
            default = 9300;
            description = ''
              Elasticsearch port for node-to-node communication.
            '';
          };

          clusterName = lib.mkOption {
            type = types.str;
            default = "elasticsearch";
            description = ''
              Elasticsearch cluster name for auto-discovery.
            '';
          };

          singleNode = lib.mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether to start a single-node cluster.
            '';
          };

          memoryLimit = lib.mkOption {
            type = types.str;
            default = "512m";
            description = ''
              Memory limit for Elasticsearch JVM heap.
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snowblower = {
          docker-compose.services.elasticsearch = {
            enable = true;
            service = {
              inherit (cfg) image;
              ports = [
                "${toString cfg.settings.port}:9200"
                "${toString cfg.settings.tcpPort}:9300"
              ];
              volumes = ["${toString config.snowblower.env.ELASTICSEARCH_DATA}:/usr/share/elasticsearch/data"];
              restart = "unless-stopped";
              environment = {
                "discovery.type" = lib.mkIf cfg.settings.singleNode "single-node";
                "ES_JAVA_OPTS" = "-Xms${cfg.settings.memoryLimit} -Xmx${cfg.settings.memoryLimit}";
                "cluster.name" = cfg.settings.clusterName;
                "xpack.security.enabled" = "false";
                "xpack.security.enrollment.enabled" = "false";
              };
              healthcheck = {
                test = ["CMD-SHELL" "curl -s http://localhost:9200 >/dev/null || exit 1"];
                interval = "30s";
                timeout = "10s";
                retries = 3;
              };
              ulimits = {
                memlock = {
                  soft = -1;
                  hard = -1;
                };
                nofile = {
                  soft = 65536;
                  hard = 65536;
                };
              };
            };
          };

          env.ELASTICSEARCH_DATA = config.snowblower.env.PROJECT_STATE + "/elasticsearch";
        };
      };
    });
  };
}
