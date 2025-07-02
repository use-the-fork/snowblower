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
  }: let
    profiles = lib.flatten [
      (lib.optional manualStart "manual-start")
      (lib.optional autoStart "auto-start")
    ];

    finalCombinedService = lib.fold lib.recursiveUpdate {} [
      {
        inherit profiles;
        restart = "no";
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
        ];
        working_dir = "/workspace";
        environment = {
          "SB_PROJECT_PROFILE" = "/snowblower/profile";
          "SB_PROJECT_STATE" = "/snowblower/state";
        };
        tty = true;
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

  # From https://github.com/cidverse/container-images/blob/2895fb55bf7836bffd62346bc4e08eeb7268b721/lib/container-support.nix
  # Guy deserves a medal for this.
  mkDockerImage = pkgs: {
    name,
    version ? "latest",
    packages ? [],
    fromImage ? null,
    extraCommands ? "",
    env ? [],
    extendPath ? [],
    maxLayers ? 120,
    compressor ? "none", # "none", "gz","zstd"
  }: let
    defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin:/snowblower/profile/bin";
  in
    pkgs.dockerTools.buildLayeredImage {
      name = "localhost/snowblower/" + name;
      tag = version;
      inherit fromImage;
      inherit maxLayers;
      inherit compressor;
      inherit extraCommands;

      contents =
        [
          pkgs.bashInteractive # None Interactive bash shell
          pkgs.dockerTools.usrBinEnv # /usr/bin/env
          pkgs.dockerTools.caCertificates # SSL/TLS certificates
          pkgs.shadow

          pkgs.uutils-coreutils-noprefix # Core utilities like ls, cat, etc but in rust

          pkgs.tini # Default process supervisor (https://github.com/krallin/tini)

          pkgs.glibc # Standard C library
        ]
        ++ packages;

      enableFakechroot = true;
      fakeRootCommands = ''

        ${pkgs.dockerTools.shadowSetup}
        groupadd --gid ${builtins.getEnv "SB_USER_GID"} snowuser
        useradd --uid ${builtins.getEnv "SB_USER_UID"} -r -g snowuser snowuser

        mkdir -p /workspace
        chown snowuser:snowuser /workspace

        mkdir -p /tmp
        chown -R snowuser:snowuser /tmp

        mkdir -p /var
        chown -R snowuser:snowuser /var

        mkdir -p /usr/local/bin
        chown -R snowuser:snowuser /usr/local/bin

        mkdir -p /home/snowuser
        chown -R snowuser:snowuser /home/snowuser

        mkdir -p /snowblower/profile
        mkdir -p /snowblower/profile/bin
        chown -R snowuser:snowuser /snowblower/profile
      '';

      config = {
        Entrypoint = ["${lib.getExe pkgs.tini}" "--"];
        Cmd = "bash";
        Env =
          [
            "HOME=/home/snowuser"
            "DISPLAY=:0"
          ]
          ++ env
          ++ (
            if builtins.length extendPath > 0
            then [
              "PATH=${builtins.concatStringsSep ":" extendPath}:${defaultPath}"
            ]
            else []
          );
        User = "snowuser";
        WorkingDir = "/workspace";

        Labels = {
          "org.snowblower.project" = "snowblower";
          "org.snowblower.image.name" = name;
          "org.snowblower.image.version" = version;
          "org.snowblower.project.hash" = builtins.getEnv "SB_PROJECT_HASH";
        };
      };
    };
in {
  inherit mkDockerImage mkDockerService mkDockerComposeService;
}
