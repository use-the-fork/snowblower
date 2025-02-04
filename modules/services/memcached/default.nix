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
      inherit (lib) types mkOption;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.memcached;
    in {
      options.snow-blower.services.memcached = mkService {
        name = "Memcached";
        package = pkgs.memcached;
        port = 11211;
        extraOptions = {
          startArgs = lib.mkOption {
            type = types.listOf types.lines;
            default = [];
            example = ["--memory-limit=100M"];
            description = ''
              Additional arguments passed to `memcached` during startup.
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          processes.memcached = {
            exec = "${cfg.package}/bin/memcached --port=${toString cfg.settings.port} --listen=${cfg.settings.bind} ${lib.concatStringsSep " " cfg.settings.startArgs}";

            process-compose = {
              readiness_probe = {
                exec.command = ''
                  echo -e "stats\nquit" | ${pkgs.netcat}/bin/nc ${cfg.settings.host} ${toString cfg.settings.port} > /dev/null 2>&1
                '';
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
