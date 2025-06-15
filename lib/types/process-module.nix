{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable this service";
    };

    port = {
      container = mkOption {
        type = types.nullOr types.port;
        description = "The port inside the container to expose";
        default = null;
        example = 80;
      };

      host = mkOption {
        type = types.nullOr types.port;
        description = "The port on the host to map to the container port";
        default = null;
        example = 8080;
      };
    };

    exec = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run in the container";
      apply = str:
        if str == null
        then null
        else lib.strings.trim str;
    };
  };
}
