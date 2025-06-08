{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  yamlFormat = pkgs.formats.yaml {};
in {
  options = {
    enable = mkEnableOption "this service";

    # Top-level docker-compose service configuration
    service = mkOption {
      inherit (yamlFormat) type;
      default = {};
      description = "Docker Compose service configuration";
      example = lib.literalExpression ''
        {
          image = "nginx:latest";
          ports = [ "8080:80" ];
          volumes = [ "./data:/data" ];
          environment = { DEBUG = "true"; };
          restart = "unless-stopped";
        }
      '';
    };

    # For backward compatibility and convenience
    volumes = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Volume mappings. Named volumes will be created in the project state directory.
        Paths starting with "./" or "/" will be treated as bind mounts from the host.
      '';
      example = lib.literalExpression ''[ "./data:/data" "volume_name:/var/lib/postgresql/data" ]'';
    };

    networks = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Networks to connect the container to.";
      example = lib.literalExpression ''[ "frontend" "backend" ]'';
    };

    outputs.service = mkOption {
      type = types.attrs;
      readOnly = true;
      internal = true;
      description = ''
        The service definition for the docker-compose.yml file.
      '';
      default =
        if config.enable
        then
          config.service
          // (
            lib.optionalAttrs (config.volumes != []) {inherit (config) volumes;}
            // lib.optionalAttrs (config.networks != []) {inherit (config) networks;}
          )
        else {};
    };
  };
}
