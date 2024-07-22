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
      inherit (lib) types mkOption optionalString;
      inherit (self.lib.sb) mkService;

      cfg = config.snow-blower.services.redis;
    in {
      options.snow-blower.services.redis = mkService {
        name = "Redis";
        package = pkgs.redis;
        port = 6379;
        extraOptions = {
          extraConfig = mkOption {
            type = types.lines;
            default = "locale-collate C";
            description = "Additional text to be appended to `redis.conf`.";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];
          env.REDISDATA = config.snow-blower.env.PROJECT_STATE + "/redis";

          process-compose.processes.redis = let
            redisConfig = pkgs.writeText "redis.conf" ''
              port ${toString cfg.settings.port}
              ${optionalString (cfg.settings.host != null) "bind ${cfg.settings.host}"}
              ${cfg.settings.extraConfig}
            '';

            startScript = pkgs.writeShellScriptBin "start-redis" ''
              set -euo pipefail

              if [[ ! -d "$REDISDATA" ]]; then
                mkdir -p "$REDISDATA"
              fi

              exec ${cfg.package}/bin/redis-server ${redisConfig} --dir "$REDISDATA"
            '';
          in {
            exec = "${startScript}/bin/start-redis";

            process-compose = {
              readiness_probe = {
                exec.command = "${cfg.package}/bin/redis-cli -p ${toString cfg.settings.port} ping";
                initial_delay_seconds = 2;
                period_seconds = 10;
                timeout_seconds = 4;
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
