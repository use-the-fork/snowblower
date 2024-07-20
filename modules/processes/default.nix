{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.processes = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }:
      with lib; let
        cfg = config.snow-blower.process-compose;
        settingsFormat = pkgs.formats.yaml {};

        envList =
          lib.mapAttrsToList
          (name: value: "${name}=${builtins.toJSON value}")
          config.snow-blower.env;

        processType = types.submodule (_: {
          options = {
            exec = lib.mkOption {
              type = types.str;
              description = "Bash code to run the process.";
            };

            process-compose = lib.mkOption {
              type = types.attrs; # TODO: type this explicitly?
              default = {};
              description = ''
                process-compose.yaml specific process attributes.

                Example: https://github.com/F1bonacc1/process-compose/blob/main/process-compose.yaml`

                Only used when using ``process.implementation = "process-compose";``
              '';
              example = {
                environment = ["ENVVAR_FOR_THIS_PROCESS_ONLY=foobar"];
                availability = {
                  restart = "on_failure";
                  backoff_seconds = 2;
                  max_restarts = 5; # default: 0 (unlimited)
                };
                depends_on.some-other-process.condition = "process_completed_successfully";
              };
            };
          };
        });
      in {
        options.snow-blower.process-compose = {
          processes = lib.mkOption {
            type = types.attrsOf processType;
            default = {};
            description = "Processes can be started with ``just up`` and run in foreground mode.";
          };

          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.process-compose;
            defaultText = lib.literalExpression "pkgs.process-compose";
            description = "The process-compose package to use.";
          };

          settings = {
            server = lib.mkOption {
              # NOTE: https://github.com/F1bonacc1/process-compose/blob/1c706e7c300df2455de7a9b259dd35dea845dcf3/src/app/config.go#L11-L16
              type = types.attrs;
              description = ''
                Top-level process-compose.yaml options when that implementation is used.
              '';
              default = {
                version = "0.5";
                unix-socket = "${config.snow-blower.paths.runtime}/pc.sock";
                tui = true;
              };
              defaultText = lib.literalExpression ''
                {
                  version = "0.5";
                  unix-socket = "''${config.snow-blower.paths.runtime}/pc.sock";
                  tui = true;
                }
              '';
              example = {
                version = "0.5";
                log_location = "/path/to/combined/output/logfile.log";
                log_level = "fatal";
              };
            };

            before = lib.mkOption {
              type = types.lines;
              description = "Bash code to execute before starting processes.";
              default = "";
            };

            after = lib.mkOption {
              type = types.lines;
              description = "Bash code to execute after stopping processes.";
              default = "";
            };
          };

          internals = {
            command = lib.mkOption {
              type = types.str;
              internal = true;
              description = ''
                The command to run the process-manager. This is meant to be set by the process-manager.''${implementation}.
              '';
            };

            procfile = lib.mkOption {
              type = types.package;
              internal = true;
            };

            procfileEnv = lib.mkOption {
              internal = true;
              type = types.package;
            };

            procfileScript = lib.mkOption {
              type = types.package;
              internal = true;
              default = pkgs.writeShellScript "no-processes" "";
            };

            configFile = lib.mkOption {
              type = lib.types.path;
              internal = true;
            };

            settings = lib.mkOption {
              type = settingsFormat.type;
              default = {};
              internal = true;
              description = ''
                process-compose.yaml specific process attributes.

                Example: https://github.com/F1bonacc1/process-compose/blob/main/process-compose.yaml`
              '';
              example = {
                environment = ["ENVVAR_FOR_THIS_PROCESS_ONLY=foobar"];
                availability = {
                  restart = "on_failure";
                  backoff_seconds = 2;
                  max_restarts = 5; # default: 0 (unlimited)
                };
                depends_on.some-other-process.condition = "process_completed_successfully";
              };
            };
          };
        };

        config = lib.mkIf (cfg.processes != {}) {
          #Expose process-compose as a buildable package.

          snow-blower = {
            packages = [cfg.package];

            process-compose = {
              settings.server = {
                version = "0.5";
                is_strict = true;
                port = lib.mkDefault 9999;
                tui = lib.mkDefault true;
                environment =
                  lib.mapAttrsToList
                  (name: value: "${name}=${toString value}")
                  config.snow-blower.env;
                processes =
                  lib.mapAttrs
                  (name: value: {command = "exec ${pkgs.writeShellScript name value.exec}";} // value.process-compose)
                  cfg.processes;
              };

              internals = {
                command = ''
                  ${cfg.package}/bin/process-compose --config ${cfg.internals.configFile} \
                    --unix-socket ''${PC_SOCKET_PATH:-${toString cfg.settings.server.unix-socket}} \
                    --tui=''${PC_TUI_ENABLED:-${lib.boolToString cfg.settings.server.tui}} \
                    -U up "$@" &
                '';

                procfile = pkgs.writeText "procfile" (lib.concatStringsSep "\n"
                  (lib.mapAttrsToList (name: process: "${name}: exec ${pkgs.writeShellScript name process.exec}")
                    cfg.processes));

                procfileEnv =
                  pkgs.writeText "procfile-env" (lib.concatStringsSep "\n" envList);

                procfileScript = pkgs.writeShellScript "process-compose-up" ''
                  ${cfg.settings.before}

                  echo "HERE I AM"
                  echo "${cfg.internals.configFile}"

                  ${cfg.internals.command}


                  backgroundPID=$!

                  down() {
                    echo "Stopping processes..."
                    kill -TERM $backgroundPID
                    wait $backgroundPID
                    ${cfg.settings.after}
                    echo "Processes stopped."

                  }

                  trap down SIGINT SIGTERM

                  wait
                '';

                configFile = settingsFormat.generate "process-compose.yaml" cfg.settings.server;
              };

              just.recipes.up = {
                enable = lib.mkDefault true;
                justfile = lib.mkDefault ''
                  # Starts the environment.
                  up:
                    ${config.snow-blower.process-compose.internals.procfileScript}
                '';
              };
            };
          };
        };
      });
  };
}
