{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) either str int;

  # All Credit for this bad boy goes to NotAShelf.
  # https://github.com/NotAShelf/nyx/

  # The `mkDockerService` function takes a few arguments to generate
  # a module for a service without repeating the same options
  # over and over: every online service needs a host and a port.
  mkDockerService = {
    name,
    image,
    port ? 0, # default port should be a stub
    extraOptions ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} docker service";
    image = mkOption {
      type = lib.types.str;
      description = "The image ${name} should use.";
      default = image;
    };
    settings =
      {
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

  # The `mkIntegration` function creates a standardized module for integrations
  # with consistent options and behavior. It reduces boilerplate when defining
  # new integration modules.
  mkIntegration = {
    name,
    package,
    settingsFormat ? pkgs.formats.yaml {},
  }: {
    # Standard enable option for the integration
    enable = mkEnableOption "${name} integration";

    # Package option with appropriate default
    package = mkOption {
      type = lib.types.package;
      description = "The ${name} package to use.";
      default = package;
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      description = "Configuration settings for ${name}.";
      default = {};
    };
  };
in {
  inherit mkDockerService mkIntegration;
}
