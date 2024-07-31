{
  inputs,
  flake-parts-lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }: let
      inherit (lib) mkOption mkIf;
      inherit (lib) types;
      inherit (import ../utils.nix {inherit lib;}) mkIntegration;

      cfg = config.snow-blower.integrations.supervisorctl;
      supervisor = cfg.package;
    in {
      options.snow-blower.integrations.supervisorctl = mkIntegration {
        name = "Supervisor";
        package = pkgs.python312Packages.supervisor;
        settings = {
          file-name = mkOption {
            type = types.str;
            description = lib.mdDoc "The name of the file to output the chaneglog to.";
            default = "CHANGELOG.md";
          };
        };
      };

      config.snow-blower.integrations.supervisorctl =
        lib.mkIf cfg.enable {
        };
    });
  };
}
#{ config, lib, pkgs, ... }:
#
#let
#
#  cfg = config.services.supervisor;
#  supervisor = cfg.package;
#
#
#
#in
#{
#  options.snow-blower.intigrations,.supervisor.services.supervisor = {
#    enable = mkEnableOption "Supervisor Service";
#
#    package = mkOption {
#      type = types.package;
#      default = pkgs.python312Packages.supervisor;
#      description = "Supervisor package";
#    };
#
#    supervisorctl = {
#      enable = mkEnableOption "Enable supervisorctl";
#      url = mkOption {
#        type = types.str;
#        default = "http://localhost";
#        description = "URL for supervisorctl";
#      };
#      port = mkOption {
#        type = types.int;
#        default = 65123;
#        description = "Port for supervisorctl";
#      };
#    };
#
#    programs = mkOption {
#      type = types.attrsOf (types.submodule {
#        options = {
#          enable = mkEnableOption "Enable this program";
#          program = mkOption {
#            type = types.lines;
#            description = "The program configuration. See http://supervisord.org/configuration.html#program-x-section-settings";
#          };
#        };
#      });
#      default = { };
#      description = "Configuration for each program.";
#    };
#  };
#
#  config = mkIf cfg.enable {
#    packages = [
#      cfg.package
#    ];
#
#    snow-blower.processes.supervisor.exec = ''
#      set -euxo pipefail
#      exec ${supervisorWrapper}
#    '';
#
#    snow-blower.scripts = mkIf cfg.supervisorctl.enable {
#      supervisorctl = {
#        exec = ''
#          set -euxo pipefail
#          exec ${supervisorctlWrapper}
#        '';
#      };
#    };
#  };
#}

