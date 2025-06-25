{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption mkDockerService;

    cfg = config.snowblower.service.dockwatch;
  in {
    options.snowblower.service.dockwatch = mkDockerService {
      name = "Portainer";
      image = "ghcr.io/notifiarr/dockwatch:main";
      port = 9443;
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.service.dockwatch = {
          enable = true;
          service = {
            inherit (cfg) image;
            container_name = "dockwatch";
            ports = ["${toString cfg.settings.port}:80"];
            volumes = [
              "${toString config.snowblower.environmentVariables.DOCKWATCHDATA}:/config"
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
            environment = {
              PUID = "1001";
              PGID = "999";
              TZ = "America/New_York";
            };
            restart = "unless-stopped";
          };
        };

        environmentVariables.DOCKWATCHDATA = "\${SB_PROJECT_STATE}/dockwatch";
      };
    };
  });
}
