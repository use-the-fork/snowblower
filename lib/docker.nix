{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  inherit
    (lib.types)
    str
    int
    either
    ;

  # Function to generate common flags object based on options
  mkDockerComposeService = {
    service ? {},
    manualStart ? false,
    autoStart ? false,
    runtime ? false,
    network ? true,
    environment ? true,
  }: let
    profiles = lib.flatten [
      (lib.optional manualStart "manual-start")
      (lib.optional autoStart "auto-start")
    ];

    finalCombinedService = lib.fold lib.recursiveUpdate {} [
      {
        inherit profiles;
        restart = "no";
        user = "$\{SB_USER_UID}:\${SB_USER_GID}";
      }
      (lib.optionalAttrs network {
        networks = ["snownet"];
      })
      (lib.optionalAttrs runtime {
        depends_on = [];
        image = "localhost/snowblower/runtime:latest";
        volumes = [
          ".:/workspace"
          "\${SB_PROJECT_PROFILE:-/tmp/snowblower/profile}:/snowblower/profile"
          "\${SB_PROJECT_STATE:-/tmp/snowblower/state}:/snowblower/state"
          "\${SB_PROJECT_ROOT:-/tmp/snowblower}:/snowblower"
        ];
        environment = {
          "SB_SERVICE_TYPE" = "runtime";
        };
        working_dir = "/workspace";
        tty = true;
      })
      (lib.optionalAttrs environment {
        environment = {
          "SB_USER_UID" = "\${SB_USER_UID}";
          "SB_USER_GID" = "\${SB_USER_GID}";
          "SB_WORKSPACE_ROOT" = "/workspace";
          "SB_PROJECT_ROOT" = "/snowblower";
          "SB_PROJECT_PROFILE" = "/snowblower/profile";
          "SB_PROJECT_STATE" = "/snowblower/state";
          "SB_PROJECT_HASH" = "\${SB_PROJECT_HASH}";
        };
      })
      service
    ];
  in
    finalCombinedService;

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
in {
  inherit mkDockerService mkDockerComposeService;
}
