{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption mkDockerService;

    cfg = config.snowblower.service.oxker;
  in {
    options.snowblower.service.oxker = mkDockerService {
      name = "Oxker";
      image = "ghcr.io/mrjackwills/oxker:latest";
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        command."oxker" = {
          displayName = "Oxker";
          description = "Docker containers TUI";
          command = "oxker";
          env = "service";
        };

        docker.service.oxker = {
          enable = true;
          service = {
            inherit (cfg) image;
            container_name = "oxker";
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];
            restart = "no";
            profiles = [
              "no-start"
            ];
          };
        };
      };
    };
  });
}
