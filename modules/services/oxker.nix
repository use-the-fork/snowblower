{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.sbl.docker) mkDockerService mkCommonFlags;

    cfg = config.snowblower.service.oxker;
  in {
    options.snowblower.service.oxker = mkDockerService {
      name = "Oxker";
      image = "ghcr.io/mrjackwills/oxker:latest";
    };

    config = {
      snowblower = {
        command."oxker" = {
          displayName = "Oxker";
          description = "Docker containers TUI";
          command = "oxker";
          env = "service";
        };

        # This service is auto included as it's auto started with snow.
        docker.service.oxker = {
          enable = true;
          service = {
            inherit (cfg) image;
            container_name = "oxker";
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];
            "sb-common" = mkCommonFlags {manualStart = true;};
          };
        };
      };
    };
  });
}
