{flake-parts-lib, ...}: {
  imports = [
    #./kibana.nix
  ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.sbl.docker) mkDockerService mkDockerComposeService;

    cfg = config.snowblower.service.elasticsearch;
  in {
    options.snowblower.service.elasticsearch = mkDockerService {
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
        docker.service.elasticsearch = {
          enable = true;
          service = mkDockerComposeService {
            service = {
              inherit (cfg) image;
              ports = [
                "${toString cfg.settings.port}:9200"
                "${toString cfg.settings.tcpPort}:9300"
              ];
              volumes = ["${toString config.snowblower.environmentVariables.ELASTICSEARCH_DATA}:/usr/share/elasticsearch/data"];
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
            autoStart = true;
          };
        };

        environmentVariables.ELASTICSEARCH_DATA = "\${PROJECT_STATE}/elasticsearch";
      };
    };
  });
}
