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
      pkgs,
      config,
      system,
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.elasticsearch.kibana;
      elasticsearchCfg = config.snow-blower.services.elasticsearch;
    in {
      options.snow-blower.services.elasticsearch.kibana = mkService {
        name = "Kibana";
        package = self.packages."${system}".kibana;
        port = 5601;
        extraOptions = {
          hosts = mkOption {
            description = ''
              The URLs of the Elasticsearch instances to use for all your queries.
              All nodes listed here must be on the same cluster.

              Defaults to <literal>[ "http://localhost:9200" ]</literal>.

              This option is only valid when using kibana >= 6.6.
            '';
            default = [
              "http://${elasticsearchCfg.settings.host}:${toString elasticsearchCfg.settings.port}"
            ];
            type = types.nullOr (types.listOf types.str);
          };

          extraConf = mkOption {
            description = "Extra configuration for elasticsearch.";
            default = "";
            type = types.str;
            example = ''
              node.name: "elasticsearch"
              node.master: true
              node.data: false
            '';
          };

          extraCmdLineOptions = mkOption {
            description = "Extra command line options for the elasticsearch launcher.";
            default = [];
            type = types.listOf types.str;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          env = {
            KIBANA_DATA = config.snow-blower.env.PROJECT_STATE + "/kibana";
          };

          processes.kibana = let
            kibanaConfig = ''
              server.host: ${cfg.settings.host}
              server.port: ${toString cfg.settings.port}
              elasticsearch.hosts: [ "http://${elasticsearchCfg.settings.host}:${toString elasticsearchCfg.settings.port}" ]
            '';

            kibanaYml = pkgs.writeTextFile {
              name = "kibana.yml";
              text = kibanaConfig;
            };

            startScript = pkgs.writeShellScript "kibana-startup" ''
              set -e

              mkdir -p "$KIBANA_DATA"

              # Start it
              exec ${cfg.package}/bin/kibana --config "${kibanaYml}"  --path.data "$KIBANA_DATA" ${toString cfg.settings.extraCmdLineOptions}
            '';
          in {
            exec = "${startScript}";

            process-compose = {
              readiness_probe = {
                exec.command = "${pkgs.curl}/bin/curl -f -k http://${cfg.settings.host}:${toString cfg.settings.port}";
                initial_delay_seconds = 15;
                period_seconds = 10;
                timeout_seconds = 2;
                success_threshold = 1;
                failure_threshold = 5;
              };

              # https://github.com/F1bonacc1/process-compose#-auto-restart-if-not-healthy
              availability.restart = "on_failure";
            };
          };
        };
      };
    });
  };
}
