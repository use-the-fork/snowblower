{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./kibana.nix
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption optionalString literalExpression;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.elasticsearch;
    in {
      options.snow-blower.services.elasticsearch = mkService {
        name = "Elasticsearch";
        package = pkgs.elasticsearch;
        port = 9200;
        extraOptions = {
          tcp_port = mkOption {
            description = "Elasticsearch port for the node to node communication.";
            default = 9300;
            type = types.int;
          };

          cluster_name = mkOption {
            description = "Elasticsearch name that identifies your cluster for auto-discovery.";
            default = "elasticsearch";
            type = types.str;
          };

          single_node = mkOption {
            description = "Start a single-node cluster";
            default = true;
            type = types.bool;
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

          logging = mkOption {
            description = "Elasticsearch logging configuration.";
            default = ''
              logger.action.name = org.elasticsearch.action
              logger.action.level = info
              appender.console.type = Console
              appender.console.name = console
              appender.console.layout.type = PatternLayout
              appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n
              rootLogger.level = info
              rootLogger.appenderRef.console.ref = console
            '';
            type = types.str;
          };

          extraCmdLineOptions = mkOption {
            description = "Extra command line options for the elasticsearch launcher.";
            default = [];
            type = types.listOf types.str;
          };

          extraJavaOptions = mkOption {
            description = "Extra command line options for Java.";
            default = [];
            type = types.listOf types.str;
            example = ["-Djava.net.preferIPv4Stack=true"];
          };

          plugins = mkOption {
            description = "Extra elasticsearch plugins";
            default = [];
            type = types.listOf types.package;
            example =
              literalExpression "[ pkgs.elasticsearchPlugins.discovery-ec2 ]";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          env.ELASTICSEARCH_DATA = config.snow-blower.env.PROJECT_STATE + "/elasticsearch";

          env.KIBANA_DATA = config.snow-blower.env.PROJECT_STATE + "/kibana";

          processes.elasticsearch = let
            esConfig = ''
              http.cors.allow-origin: "*"
              http.cors.enabled: true
              http.cors.allow-credentials: true
              http.cors.allow-methods: OPTIONS, HEAD, GET, POST, PUT, DELETE
              http.cors.allow-headers: X-Requested-With, X-Auth-Token, Content-Type, Content-Length, Authorization, Access-Control-Allow-Headers, Accept, x-elastic-client-meta
              network.host: ${cfg.settings.host}
              cluster.name: ${cfg.settings.cluster_name}
              ${lib.optionalString cfg.settings.single_node "discovery.type: single-node"}
              http.port: ${toString cfg.settings.port}
              transport.port: ${toString cfg.settings.tcp_port}
              ${cfg.settings.extraConf}
            '';

            elasticsearchYml = pkgs.writeTextFile {
              name = "elasticsearch.yml";
              text = esConfig;
            };

            loggingConfigFilename = "log4j2.properties";
            loggingConfigFile = pkgs.writeTextFile {
              name = loggingConfigFilename;
              text = cfg.settings.logging;
            };

            esPlugins = pkgs.buildEnv {
              name = "elasticsearch-plugins";
              paths = cfg.settings.plugins;
              postBuild = "${pkgs.coreutils}/bin/mkdir -p $out/plugins";
            };

            startScript = pkgs.writeShellScript "es-startup" ''
              set -e

              export ES_HOME="$ELASTICSEARCH_DATA"
              export ES_JAVA_OPTS="${toString cfg.settings.extraJavaOptions}"
              export ES_PATH_CONF="$ELASTICSEARCH_DATA/config"
              mkdir -m 0700 -p "$ELASTICSEARCH_DATA"
              # Install plugins
              rm -f "$ELASTICSEARCH_DATA/plugins"
              ln -sf ${esPlugins}/plugins "$ELASTICSEARCH_DATA/plugins"
              rm -f "$ELASTICSEARCH_DATA/lib"
              ln -sf ${cfg.package}/lib "$ELASTICSEARCH_DATA/lib"
              rm -f "$ELASTICSEARCH_DATA/modules"
              ln -sf ${cfg.package}/modules "$ELASTICSEARCH_DATA/modules"

              # Create config dir
              mkdir -m 0700 -p "$ELASTICSEARCH_DATA/config"
              rm -f "$ELASTICSEARCH_DATA/config/elasticsearch.yml"
              cp ${elasticsearchYml} "$ELASTICSEARCH_DATA/config/elasticsearch.yml"
              rm -f "$ELASTICSEARCH_DATA/logging.yml"
              rm -f "$ELASTICSEARCH_DATA/config/${loggingConfigFilename}"
              cp ${loggingConfigFile} "$ELASTICSEARCH_DATA/config/${loggingConfigFilename}"

              mkdir -p "$ELASTICSEARCH_DATA/scripts"
              rm -f "$ELASTICSEARCH_DATA/config/jvm.options"

              cp ${cfg.package}/config/jvm.options "$ELASTICSEARCH_DATA/config/jvm.options"

              # Create log dir
              mkdir -m 0700 -p "$ELASTICSEARCH_DATA/logs"

              # Start it
              exec ${cfg.package}/bin/elasticsearch ${toString cfg.settings.extraCmdLineOptions}
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
