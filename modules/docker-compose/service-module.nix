{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options = {
    enable = mkEnableOption "this service";

    image = mkOption {
      type = types.str;
      description = "OCI image to run.";
      example = "nginx:latest";
    };

    ports = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Ports to publish from the container to the host.";
      example = lib.literalExpression ''[ "8080:80" "443:443" ]'';
    };

    volumes = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Volume mappings. Named volumes will be created in the project state directory.
        Paths starting with "./" or "/" will be treated as bind mounts from the host.
      '';
      example = lib.literalExpression ''[ "./data:/data" "volume_name:/var/lib/postgresql/data" ]'';
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Environment variables to set for the container.";
      example = lib.literalExpression ''{ POSTGRES_PASSWORD = "secret"; }'';
    };

    environmentFiles = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Environment variable files to use.";
      example = lib.literalExpression ''[ "./.env" ]'';
    };

    dependsOn = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Services that this service depends on.";
      example = lib.literalExpression ''[ "db" "redis" ]'';
    };

    restart = mkOption {
      type = types.enum ["no" "always" "on-failure" "unless-stopped"];
      default = "no";
      description = "Restart policy for the container.";
    };

    networks = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Networks to connect the container to.";
      example = lib.literalExpression ''[ "frontend" "backend" ]'';
    };

    extraOptions = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "Additional options for the container.";
      example = lib.literalExpression ''
        {
          cap_add = [ "NET_ADMIN" ];
          command = ["nginx" "-g" "daemon off;"];
          user = "nginx";
        }
      '';
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
          {
            image = config.image;
            ports = config.ports;
            volumes = config.volumes;
            environment = config.environment;
            env_file = config.environmentFiles;
            depends_on = config.dependsOn;
            restart = config.restart;
            networks = config.networks;
          }
          // config.extraOptions
        else {};
    };
  };
}
