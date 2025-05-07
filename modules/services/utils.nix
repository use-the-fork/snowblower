{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) either str int;

  # All Credit for this bad boy goes to NotAShelf.
  # https://github.com/NotAShelf/nyx/

  # The `mkService` function takes a few arguments to generate
  # a module for a service without repeating the same options
  # over and over: every online service needs a host and a port.
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
      type = lib.types.package;
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
          type = either int str;
          default = port;
          description = "The port ${name} will listen on";
          apply = value:
            if lib.isString value
            then lib.toInt value
            else value;
        };
      }
      // extraOptions;
  };

in {
  inherit mkService;
}
