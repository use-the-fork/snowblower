{
  inputs,
  flake-parts-lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) mkOption mkIf;
      inherit (lib) types;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.supervisorctl;
      env = config.snow-blower.env;
      supervisor = cfg.package;
    in {
      options.snow-blower.services.supervisorctl =
        mkService {
          name = "Supervisor";
          package = pkgs.python312Packages.supervisor;
        }
        // {
          programs = mkOption {
            type = types.attrsOf (types.submodule {
              options = {
                enable = mkEnableOption "Enable this program";
                program = mkOption {
                  type = types.lines;
                  description = "The program configuration. See http://supervisord.org/configuration.html#program-x-section-settings";
                };
              };
            });
            default = {};
            description = "Configuration for each program.";
          };
        };
      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];
          env.SUPERVISORD_DATA = config.snow-blower.env.PROJECT_STATE + "/supervisord";
          env.SUPERVISORD_UNIX_PORT = config.snow-blower.env.PROJECT_RUNTIME + "/supervisor.sock";
          env.SUPERVISORD_PID = config.snow-blower.env.PROJECT_RUNTIME + "/supervisor.pid";

          services.supervisorctl = let
            programSections = lib.concatStringsSep "\n" (lib.filter (s: s != "") (lib.mapAttrsToList (
                _name: program:
                  if program.enable
                  then program.program
                  else ""
              )
              cfg.programs));

            configFile = pkgs.writeText "supervisor.conf" ''
              [unix_http_server]
              file=${toString env.SUPERVISORD_UNIX_PORT}

              [supervisord]
              pidfile=${env.SUPERVISORD_PID}
              childlogdir=${env.SUPERVISORD_DATA}/log/
              logfile=${env.SUPERVISORD_DATA}/log/supervisor.log
              environment = KEY1="value1",KEY2="value2"

              [supervisorctl]
              serverurl=unix://${toString env.SUPERVISORD_UNIX_PORT}

              ${programSections}

              [rpcinterface:supervisor]
              supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
            '';

            supervisorWrapper = pkgs.writeScript "supervisor-wrapper" ''
              #!/usr/bin/env bash

              mkdir -m 0700 -p "${env.SUPERVISORD_DATA}/log"

              export PATH="${pkgs.coreutils}/bin"

              # Run supervisor
              ${supervisor}/bin/supervisord \
               --configuration=${configFile} \
               --nodaemon \
               --pidfile=${env.SUPERVISORD_DATA}/supervisor/run/supervisor.pid \
               --childlogdir=${env.SUPERVISORD_DATA}/supervisor/log/ \
               --logfile=${env.SUPERVISORD_DATA}/supervisor/log/supervisor.log
            '';
          in {
            processes.supervisor.exec = ''
              set -euxo pipefail
              exec ${supervisorWrapper}
            '';
          };
        };
      };
    });
  };
}
