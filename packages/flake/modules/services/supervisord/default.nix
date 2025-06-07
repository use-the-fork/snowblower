{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) mkOption mkIf mkEnableOption;
      inherit (lib) types;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.supervisord;
      supervisor = cfg.package;

      programSections = lib.concatStringsSep "\n" (lib.filter (s: s != "") (lib.mapAttrsToList (
          _name: program:
            if program.enable
            then program.program
            else ""
        )
        cfg.programs));

      configFile = pkgs.writeText "supervisor.conf" ''
        [unix_http_server]
        file=${toString config.snow-blower.env.SUPERVISORD_UNIX_PORT}

        [supervisord]
        pidfile=${config.snow-blower.env.SUPERVISORD_PID}
        childlogdir=${config.snow-blower.env.SUPERVISORD_DATA}/log/
        logfile=${config.snow-blower.env.SUPERVISORD_DATA}/log/supervisor.log

        [supervisorctl]
        serverurl=unix://${toString config.snow-blower.env.SUPERVISORD_UNIX_PORT}

        ${programSections}

        [rpcinterface:supervisor]
        supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
      '';

      supervisorWrapper = pkgs.writeScript "supervisor-wrapper" ''
        #!/usr/bin/env bash

        mkdir -m 0700 -p "$SUPERVISORD_DATA/log"

        export PATH="${pkgs.coreutils}/bin"

        # Run supervisor
        ${supervisor}/bin/supervisord \
         --configuration=${configFile} \
         --nodaemon
      '';
    in {
      options.snow-blower.services.supervisord =
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

          env = {
            SUPERVISORD_DATA = config.snow-blower.env.PROJECT_STATE + "/supervisord";
            SUPERVISORD_UNIX_PORT = config.snow-blower.env.PROJECT_RUNTIME + "/supervisor.sock";
            SUPERVISORD_PID = config.snow-blower.env.PROJECT_RUNTIME + "/supervisor.pid";
          };

          processes.supervisor = {
            exec = ''
              set -euxo pipefail
              exec ${supervisorWrapper}
            '';
          };
        };
      };
    });
  };
}
