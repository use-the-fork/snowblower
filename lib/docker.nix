{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  inherit
    (lib.types)
    oneOf
    listOf
    attrsOf
    str
    bool
    int
    float
    path
    either
    ;

  valueType = oneOf [
    bool
    int
    float
    str
    path
    (attrsOf valueType)
    (listOf valueType)
  ];

  # Function to generate common flags array based on options
  mkCommonFlags = {
    manualStart ? false,
    autoStart ? false,
    runtime ? false,
    network ? true,
  }:
    lib.flatten [
      (lib.optional manualStart "*use-manual-start")
      (lib.optional autoStart "*use-auto-start")
      (lib.optional runtime "*use-runtime")
      (lib.optional network "*use-network")
    ];

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
    basePackageSet ? "minimal",
    extraCommands ? "",
    maxLayers ? 120,
    compressor ? "none", # "none", "gz","zstd"
    entrypoint ? null,
    volumes ? {},
    env ? [],
    extendPath ? [],
  }: let
    createDirs = pkgs.runCommand "tmp" {} ''
      mkdir $out
      mkdir -m 0770 $out/tmp
      mkdir -m 0770 $out/var
      mkdir -m 0770 -p $out/usr/local/bin
      mkdir -m 0770 -p $out/home/snowuser
    '';

    microBasePackages = [
      pkgs.dockerTools.binSh # /bin/sh
      pkgs.dockerTools.usrBinEnv # /usr/bin/env
      pkgs.dockerTools.caCertificates # SSL/TLS certificates

      pkgs.bashInteractive # None Interactive bash shell
      pkgs.uutils-coreutils-noprefix # Core utilities like ls, cat, etc but in rust

      pkgs.iana-etc # /etc/services and related files
      pkgs.tzdata # Timezone data

      pkgs.dumb-init # Default process supervisor (https://github.com/Yelp/dumb-init)

      createDirs
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
        "dumb-init"
        "/usr/bin/env"
        "bash"
      ];
      "minimal" = [
        "dumb-init"
        "/usr/bin/env"
        "bash"
      ];
    };

    basePackageDefaultEntrypoint = {
      "micro" =
        [
          "dumb-init"
          "with-snowblower"
        ]
        ++ (
          if entrypoint != null
          then ["exec" entrypoint]
          else []
        );
      "minimal" =
        [
          "dumb-init"
          "with-snowblower"
        ]
        ++ (
          if entrypoint != null
          then ["exec" entrypoint]
          else []
        );
    };

    basePackages = basePackageSets.${basePackageSet};
    contents = basePackages ++ packages;
    defaultCmd = basePackageDefaultCmds.${basePackageSet};

    defaultEntrypoint = basePackageDefaultEntrypoint.${basePackageSet};

    defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
  in
    pkgs.dockerTools.buildLayeredImage {
      name = "localhost/snowblower/" + name;
      tag = version;
      inherit fromImage;
      inherit maxLayers;
      inherit compressor;

      enableFakechroot = true;

      inherit contents;
      inherit extraCommands;

      fakeRootCommands = ''
        ${pkgs.dockerTools.shadowSetup}
        groupadd --gid ${builtins.getEnv "SB_USER_GID"} snowuser
        useradd --uid ${builtins.getEnv "SB_USER_UID"} -r -g snowuser snowuser
        mkdir -p /workspace

        chown snowuser:snowuser /workspace
        chown -R snowuser:snowuser /home/snowuser

        mkdir -p /snowblower/profile
        chown -R snowuser:snowuser /snowblower/profile
      '';

      config = {
        Entrypoint = defaultEntrypoint;
        Cmd = defaultCmd;
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
      };
    };
in {
  inherit mkDockerImage mkDockerService mkCommonFlags;
}
