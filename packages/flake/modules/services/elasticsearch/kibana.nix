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

      cfg = config.snow-blower.services.elasticsearch.kibana;
    in {
      options.snow-blower.services.elasticsearch.kibana = mkDockerService {
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
        snow-blower = {
          docker-compose.services.kibana = {
            enable = true;
            service = {
              image = cfg.image;
              ports = ["${toString cfg.settings.port}:5601"];
              volumes = ["${toString config.snow-blower.env.KIBANA_DATA}:/usr/share/kibana/data"];
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
          };

          env.KIBANA_DATA = config.snow-blower.env.PROJECT_STATE + "/kibana";
        };
      };
    });
  };
}
