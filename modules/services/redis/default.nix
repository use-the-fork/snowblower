{
  inputs,
  flake-parts-lib,
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
      inherit (lib) types mkOption mkEnableOption;

      cfg = config.snow-blower.services.redis;
    in {
      options.snow-blower.services.redis = {
        enable = mkEnableOption "Redis process and expose utilities";

        package = mkOption {
          type = types.package;
          description = "Which package of Redis to use";
          default = pkgs.redis;
          defaultText = lib.literalExpression "pkgs.redis";
        };

        bind = mkOption {
          type = types.nullOr types.str;
          default = "127.0.0.1";
          description = ''
            The IP interface to bind to.
            `null` means "all interfaces".
          '';
          example = "127.0.0.1";
        };

        port = mkOption {
          type = types.port;
          default = 6379;
          description = ''
            The TCP port to accept connections.
            If port 0 is specified Redis, will not listen on a TCP socket.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "locale-collate C";
          description = "Additional text to be appended to `redis.conf`.";
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];
          env.REDISDATA = config.env.DEVENV_STATE + "/redis";
        };

        #        process-compose.watch-server = {
        #          settings = {
        #            processes.redis = {
        #              readiness_probe = {
        #                exec.command = "${startScript}/bin/start-redis";
        #                initial_delay_seconds = 2;
        #                period_seconds = 10;
        #                timeout_seconds = 4;
        #                success_threshold = 1;
        #                failure_threshold = 5;
        #              };
        #              availability.restart = "on_failure";
        #            };
        #          };
        #        };
      };
    });
  };
}
