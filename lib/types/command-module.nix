{lib, ...}: let
  inherit (lib) types mkOption;

  subCommandModule = {
    options = {
      description = mkOption {
        type = types.str;
        description = "Description of the subcommand";
      };

      cmdWithArgs = mkOption {
        type = types.str;
        description = "Command to execute for this subcommand";
        apply = str:
          if str == null
          then null
          else lib.strings.trim str;
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

    cmdWithArgs = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to execute for the general command (when no specific subcommand is provided)";
      apply = str:
        if str == null
        then null
        else lib.strings.trim str;
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
