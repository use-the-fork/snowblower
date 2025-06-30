{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption mkDockerService mkDockerServiceConfig;

    cfg = config.snowblower.service.portainer;
  in {
    options.snowblower.service.portainer = mkDockerService {
      name = "Portainer";
      image = "portainer/portainer-ce:latest";
      port = 9443;
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        docker.service.portainer = {
          enable = true;
          service =
            {
              inherit (cfg) image;
              ports = ["${toString cfg.settings.port}:9443"];
              volumes = [
                "${toString config.snowblower.environmentVariables.PORTAINERDATA}:/data"
                "/var/run/docker.sock:/var/run/docker.sock"
              ];
            }
            // mkDockerServiceConfig {autoStart = true;};
        };

        environmentVariables.PORTAINERDATA = "\${SB_PROJECT_STATE}/portainer";
      };
    };
  });
}
