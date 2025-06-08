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

      cfg = config.snowblower.services.supervisord;
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
        file=${toString config.snowblower.env.SUPERVISORD_UNIX_PORT}

        [supervisord]
        pidfile=${config.snowblower.env.SUPERVISORD_PID}
        childlogdir=${config.snowblower.env.SUPERVISORD_DATA}/log/
        logfile=${config.snowblower.env.SUPERVISORD_DATA}/log/supervisor.log

        [supervisorctl]
        serverurl=unix://${toString config.snowblower.env.SUPERVISORD_UNIX_PORT}

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
      options.snowblower.services.supervisord =
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
        snowblower = {
          packages = [
            cfg.package
          ];

          env = {
            SUPERVISORD_DATA = config.snowblower.env.PROJECT_STATE + "/supervisord";
            SUPERVISORD_UNIX_PORT = config.snowblower.env.PROJECT_RUNTIME + "/supervisor.sock";
            SUPERVISORD_PID = config.snowblower.env.PROJECT_RUNTIME + "/supervisor.pid";
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
