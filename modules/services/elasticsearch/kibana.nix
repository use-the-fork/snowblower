{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.sbl.docker) mkDockerService mkDockerServiceConfig;

    cfg = config.snowblower.service.elasticsearch.kibana;
  in {
    options.snowblower.service.elasticsearch.kibana = mkDockerService {
      name = "Kibana";
      image = "kibana:8.12.0";
      port = 5601;
      extraOptions = {
        elasticsearchHosts = lib.mkOption {
          type = types.str;
          default = "http://elasticsearch:9200";
          description = ''
            The URL of the Elasticsearch instance to use for all queries.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.services.kibana =
          {
            enable = true;
            service = {
              inherit (cfg) image;
              ports = ["${toString cfg.settings.port}:5601"];
              volumes = ["${toString config.snowblower.environmentVariables.KIBANA_DATA}:/usr/share/kibana/data"];
              restart = "unless-stopped";
              environment = {
                "ELASTICSEARCH_HOSTS" = cfg.settings.elasticsearchHosts;
                "ELASTICSEARCH_URL" = cfg.settings.elasticsearchHosts;
              };
              depends_on = ["elasticsearch"];
              healthcheck = {
                test = ["CMD-SHELL" "curl -s http://localhost:5601/api/status | grep -q 'Looking good'"];
                interval = "30s";
                timeout = "10s";
                retries = 5;
              };
            };
          }
          // mkDockerServiceConfig {autoStart = true;};

        environmentVariables.KIBANA_DATA = "\${PROJECT_STATE}/kibana";
      };
    };
  });
}
