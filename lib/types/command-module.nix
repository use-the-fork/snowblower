{lib, ...}: let
  inherit (lib) types mkOption;

  subCommandModule = {
    options = {
      description = mkOption {
        type = types.str;
        description = "Description of the subcommand";
      };

      script = mkOption {
        type = types.str;
        description = "Script to execute for this subcommand";
      };
    };
  };

  subCommandType = types.submodule subCommandModule;
in {
  options = {
    displayName = mkOption {
      type = types.str;
      description = "Display name of the command (e.g., 'NPM' for npm, 'SnowBlower' for snow)";
    };

    script = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Script to execute for the general command (when no specific subcommand is provided)";
    };

    description = mkOption {
      type = types.str;
      description = "Description of the command";
    };

    subcommand = mkOption {
      type = lib.sbl.types.dagOf subCommandType;
      default = {};
      description = "Subcommand available for this command";
    };
  };
}
