{lib, ...}: let
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

      pkgs.iana-etc # /etc/services and related files
      pkgs.tzdata # Timezone data

      pkgs.dumb-init # Default process supervisor (https://github.com/Yelp/dumb-init)

      createDirs
    ];
    minimalBasePackages = [
      pkgs.uutils-coreutils-noprefix # Core utilities like ls, cat, etc but in rust
      pkgs.glibc # Standard C library
      pkgs.bashInteractive # Interactive bash shell
    ];

    basePackageSets = {
      "micro" = microBasePackages;
      "minimal" = microBasePackages ++ minimalBasePackages;
    };
    basePackageDefaultCmds = {
      "micro" = [
        "dumb-init"
        "/usr/bin/env"
        "sh"
      ];
      "minimal" = [
        "dumb-init"
        "/usr/bin/env"
        "bash"
      ];
    };

    basePackages = basePackageSets.${basePackageSet};
    contents = basePackages ++ packages;
    defaultCmd = basePackageDefaultCmds.${basePackageSet};
    defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
  in
    pkgs.dockerTools.buildLayeredImage {
      name = "localhost/snowblower/" + name;
      tag = version;
      inherit fromImage;
      inherit maxLayers;

      enableFakechroot = true;

      inherit contents;
      inherit extraCommands;

      fakeRootCommands = ''
        ${pkgs.dockerTools.shadowSetup}
        groupadd --gid ''${USER_GID:-1000} snowuser
        useradd --uid ''${USER_UID:-1000} -r -g snowuser snowuser
        mkdir -p /workspace

        chown snowuser:snowuser /workspace
        chown -R snowuser:snowuser /home/snowuser
      '';

      config = {
        Entrypoint = entrypoint;
        Cmd = defaultCmd;
        Arg = [
          "USER_UID=\${USER_UID}"
          "USER_GID=\${USER_UID}"
        ];
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
  inherit mkDockerImage;
}
