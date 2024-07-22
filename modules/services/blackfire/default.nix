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
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (self.lib.sb) mkService;

      cfg = config.snow-blower.services.blackfire;
      settings = config.snow-blower.services.blackfire.settings;

      configFile = pkgs.writeText "blackfire.conf" ''
        [blackfire]
        server-id=${settings.server-id}
        server-token=${settings.server-token}
        socket=tcp://${cfg.host}:${toString cfg.port}
      '';
    in {
      options.snow-blower.services.blackfire = mkService {
        name = "Blackfire";
        package = pkgs.blackfire;
        port = 8307;
        extraOptions = {
          enableApm = lib.mkEnableOption ''
            Enables application performance monitoring, requires special subscription.
          '';

          client-id = lib.mkOption {
            type = lib.types.str;
            description = ''
              Sets the client id used to authenticate with Blackfire.
              You can find your personal client-id at <https://blackfire.io/my/settings/credentials>.
            '';
            default = "";
          };

          client-token = lib.mkOption {
            type = lib.types.str;
            description = ''
              Sets the client token used to authenticate with Blackfire.
              You can find your personal client-token at <https://blackfire.io/my/settings/credentials>.
            '';
            default = "";
          };

          server-id = lib.mkOption {
            type = lib.types.str;
            description = ''
              Sets the server id used to authenticate with Blackfire.
              You can find your personal server-id at <https://blackfire.io/my/settings/credentials>.
            '';
            default = "";
          };

          server-token = lib.mkOption {
            type = lib.types.str;
            description = ''
              Sets the server token used to authenticate with Blackfire.
              You can find your personal server-token at <https://blackfire.io/my/settings/credentials>.
            '';
            default = "";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          env.BLACKFIRE_AGENT_SOCKET = settings.socket;
          env.BLACKFIRE_CLIENT_ID = settings.client-id;
          env.BLACKFIRE_CLIENT_TOKEN = settings.client-token;
          env.BLACKFIRE_APM_ENABLED =
            if settings.enableApm
            then "1"
            else "0";

          processes.blackfire-agent.exec = "${lib.getExe' cfg.package "blackfire"} agent:start --config=${configFile}";
        };
      };
    });
  };
}
