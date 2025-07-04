# Inspired By: https://github.com/cidverse/container-images/blob/2895fb55bf7836bffd62346bc4e08eeb7268b721/lib/container-support.nix
# Guy deserves a medal for this.
{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption concatStringsSep;
  in {
    options.snowblower = {
      docker = {
        image = {
          runtimePackage = mkOption {
            internal = true;
            type = types.package;
            description = "The package containing the environment docker uses.";
          };
          toolsPackage = mkOption {
            internal = true;
            type = types.package;
            description = "The package containing the environment docker uses.";
          };
        };
      };
    };

    config = {
      snowblower = {
        docker = {
          image = let
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

            basePackages = [
              pkgs.bashInteractive # Non Interactive bash shell
              pkgs.dockerTools.usrBinEnv # /usr/bin/env
              pkgs.dockerTools.caCertificates # SSL/TLS certificates
              pkgs.shadow

              pkgs.uutils-coreutils-noprefix # Core utilities like ls, cat, etc but in rust

              pkgs.tini # Default process supervisor (https://github.com/krallin/tini)

              pkgs.glibc # Standard C library
            ];
          in {
            runtimePackage = pkgs.dockerTools.buildLayeredImage {
              name = "snowblower/${config.snowblower.projectHash}/runtime";
              tag = "latest";
              contents = basePackages ++ config.snowblower.packages.runtime;

              inherit enableFakechroot;
              inherit fakeRootCommands;

              config = {
                Entrypoint = ["${lib.getExe pkgs.tini}" "--"];
                Cmd = "bash";
                Env = [
                  "HOME=/home/snowuser"
                  "DISPLAY=:0"
                ];
                User = "snowuser";
                WorkingDir = "/workspace";

                Labels = {
                  "org.snowblower.project" = "snowblower";
                  "org.snowblower.image.name" = "runtime";
                  "org.snowblower.image.version" = "latest";
                  "org.snowblower.project.hash" = config.snowblower.projectHash;
                };
              };
            };

            toolsPackage = pkgs.dockerTools.buildLayeredImage {
              name = "snowblower/${config.snowblower.projectHash}/tools";
              tag = "latest";
              contents = basePackages ++ config.snowblower.packages.tools ++ config.snowblower.packages.runtime;

              inherit enableFakechroot;
              fakeRootCommands = concatStringsSep "\n" [
                fakeRootCommands
                ''
                  cp ${config.snowblower.shell.zsh.zshrcFile} /home/snowuser/.zshrc
                  chown snowuser:snowuser /home/snowuser/.zshrc
                ''
              ];

              config = {
                Entrypoint = ["${lib.getExe pkgs.tini}" "--"];
                Cmd = "zsh";
                Env = [
                  "HOME=/home/snowuser"
                  "DISPLAY=:0"
                ];
                User = "snowuser";
                WorkingDir = "/workspace";

                Labels = {
                  "org.snowblower.project" = "snowblower";
                  "org.snowblower.image.name" = "tools";
                  "org.snowblower.image.version" = "latest";
                  "org.snowblower.project.hash" = config.snowblower.projectHash;
                };
              };
            };
          };
        };
      };

      packages = {
        dockerRuntimeImagePackage = config.snowblower.docker.image.runtimePackage;
        dockerToolsImagePackage = config.snowblower.docker.image.toolsPackage;
      };
    };
  });
}
