{lib}: let
  inherit (lib) mkEnableOption mkOption types;
  inherit (lib.types) str int;
in {
  snow-blower = {
    mkService = {
      name,
      package,
      type ? "", # type being an empty string means it can be skipped, omitted
      host ? "127.0.0.1", # default to listening only on localhost
      port ? 0, # default port should be a stub
      extraOptions ? {}, # used to define additional modules
    }: {
      enable = mkEnableOption "${name} ${type} service";
      package = mkOption {
        type = lib.package;
        description = "The package ${name} should use.";
        default = package;
      };
      settings =
        {
          host = mkOption {
            type = str;
            default = host;
            description = "The host ${name} will listen on";
          };

          port = mkOption {
            type = int;
            default = port;
            description = "The port ${name} will listen on";
          };
        }
        // extraOptions;
    };
  };
}
