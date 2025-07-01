{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  inherit
    (lib.types)
    str
    int
    either
    ;

  # Function to generate common flags object based on options
  mkDockerServiceConfig = {
    manualStart ? false,
    autoStart ? false,
    runtime ? false,
    network ? true,
  }: let
    profiles = lib.flatten [
      (lib.optional manualStart "manual-start")
      (lib.optional autoStart "auto-start")
    ];
  in
    {
      inherit profiles;
      restart = "no";
    }
    // (lib.optionalAttrs network {
      networks = ["snownet"];
    })
    // (lib.optionalAttrs runtime {
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
    });

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
    basePackageSet ? "minimal", # "none", "gz","zstd"
    entrypoint ? null,
    env ? [],
  }: let
    # Pulling the debian:stable-slim base image
    debianBaseImage = pkgs.dockerTools.pullImage {
      imageName = "debian";
      imageDigest = "sha256:6fe30b9cb71d604a872557be086c74f95451fecd939d72afe3cffca3d9e60607";
      sha256 = "fMCsw+uDtIgjp7v7woohAeaks6e1RYsE4/PIsnZ/9QQ=";
      finalImageName = "debian";
      finalImageTag = "stable-slim";
    };

    microBasePackages = [
      # pkgs.dockerTools.binSh # /bin/sh
      # pkgs.dockerTools.usrBinEnv # /usr/bin/env
      # pkgs.dockerTools.caCertificates # SSL/TLS certificates

      pkgs.bashInteractive # None Interactive bash shell
      pkgs.uutils-coreutils-noprefix # Core utilities like ls, cat, etc but in rust

      # pkgs.iana-etc # /etc/services and related files
      # pkgs.tzdata # Timezone data

      # pkgs.cacert
      pkgs.tini # Default process supervisor (https://github.com/krallin/tini)

      # createDirs
    ];
    minimalBasePackages = [
      pkgs.glibc # Standard C library
    ];

    basePackageSets = {
      "micro" = microBasePackages;
      "minimal" = microBasePackages ++ minimalBasePackages;
    };

    basePackageDefaultCmds = {
      "micro" = [
        "/usr/bin/env"
        "bash"
      ];
      "minimal" = [
        "/usr/bin/env"
        "bash"
      ];
    };

    basePackageDefaultEntrypoint = {
      "micro" =
        [
          "tini"
          "--"
          "with-snowblower"
        ]
        ++ (
          if entrypoint != null
          then ["exec" entrypoint]
          else []
        );
      "minimal" =
        [
          "tini"
          "--"
          "with-snowblower"
        ]
        ++ (
          if entrypoint != null
          then ["exec" entrypoint]
          else []
        );
    };

    basePackages = basePackageSets.${basePackageSet};
    defaultCmd = basePackageDefaultCmds.${basePackageSet};

    defaultEntrypoint = basePackageDefaultEntrypoint.${basePackageSet};
  in
    pkgs.dockerTools.buildImage {
      name = "localhost/snowblower/" + name;
      tag = version;
      fromImage = debianBaseImage;

      copyToRoot = pkgs.buildEnv {
        name = "image-root";
        pathsToLink = ["/bin"];
        paths =
          [
            pkgs.shadow
            pkgs.tini
          ]
          ++ basePackages ++ packages;
      };

      runAsRoot = ''
        #!${pkgs.runtimeShell}
        mkdir -p /etc

        groupadd --gid ${builtins.getEnv "SB_USER_UID"} snowuser
        useradd --uid ${builtins.getEnv "SB_USER_UID"} -r -g snowuser snowuser

        mkdir -p /workspace
        mkdir -p /home/snowuser

        chown snowuser:snowuser /workspace
        chown -R snowuser:snowuser /home/snowuser

        mkdir -p /snowblower/profile
        chown -R snowuser:snowuser /snowblower/profile
      '';

      # inherit compressor;

      # enableFakechroot = true;

      # inherit contents;
      # inherit extraCommands;

      # fakeRootCommands = ''
      #   ${pkgs.dockerTools.shadowSetup}
      #   groupadd --gid ${builtins.getEnv "SB_USER_GID"} snowuser
      #   useradd --uid ${builtins.getEnv "SB_USER_UID"} -r -g snowuser snowuser
      #   mkdir -p /workspace

      #   chown snowuser:snowuser /workspace
      #   chown -R snowuser:snowuser /home/snowuser

      #   mkdir -p /snowblower/profile
      #   chown -R snowuser:snowuser /snowblower/profile
      # '';

      config = {
        Entrypoint = defaultEntrypoint;
        Cmd = defaultCmd;
        Env =
          [
            "HOME=/home/snowuser"
            "DISPLAY=:0"
            # "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            # "SSL_CERT_DIR=${pkgs.cacert}/etc/ssl/certs/"
          ]
          ++ env;
        User = "snowuser";
        WorkingDir = "/workspace";
      };
    };
in {
  inherit mkDockerImage mkDockerService mkDockerServiceConfig;
}
