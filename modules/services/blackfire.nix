{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption mkDockerService;

    cfg = config.snowblower.service.blackfire;
  in {
    options.snowblower.service.blackfire = mkDockerService {
      name = "Blackfire";
      image = "blackfire/blackfire:2";
      port = 8307;
      extraOptions = {
        enableApm = lib.mkEnableOption ''
          Enables application performance monitoring, requires special subscription.
        '';

        clientId = lib.mkOption {
          type = types.str;
          description = ''
            Sets the client id used to authenticate with Blackfire.
            You can find your personal client-id at <https://blackfire.io/my/settings/credentials>.
          '';
          default = "";
        };

        clientToken = lib.mkOption {
          type = types.str;
          description = ''
            Sets the client token used to authenticate with Blackfire.
            You can find your personal client-token at <https://blackfire.io/my/settings/credentials>.
          '';
          default = "";
        };

        serverId = lib.mkOption {
          type = types.str;
          description = ''
            Sets the server id used to authenticate with Blackfire.
            You can find your personal server-id at <https://blackfire.io/my/settings/credentials>.
          '';
          default = "";
        };

        serverToken = lib.mkOption {
          type = types.str;
          description = ''
            Sets the server token used to authenticate with Blackfire.
            You can find your personal server-token at <https://blackfire.io/my/settings/credentials>.
          '';
          default = "";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.services.blackfire = {
          enable = true;
          service = {
            inherit (cfg) image;
            ports = ["${toString cfg.settings.port}:8307"];
            restart = "unless-stopped";
            environment = {
              BLACKFIRE_CLIENT_ID = cfg.settings.clientId;
              BLACKFIRE_CLIENT_TOKEN = cfg.settings.clientToken;
              BLACKFIRE_SERVER_ID = cfg.settings.serverId;
              BLACKFIRE_SERVER_TOKEN = cfg.settings.serverToken;
              BLACKFIRE_LOG_LEVEL = "4";
              BLACKFIRE_APM_ENABLED =
                if cfg.settings.enableApm
                then "1"
                else "0";
            };
          };
        };

        environmentVariables = {
          BLACKFIRE_AGENT_SOCKET = "tcp://localhost:${toString cfg.settings.port}";
          BLACKFIRE_CLIENT_ID = cfg.settings.clientId;
          BLACKFIRE_CLIENT_TOKEN = cfg.settings.clientToken;
          BLACKFIRE_APM_ENABLED =
            if cfg.settings.enableApm
            then "1"
            else "0";
        };
      };
    };
  });
}
