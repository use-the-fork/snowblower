{lib, ...}: let
  inherit (lib) types mkOption;

  subCommandModule = {
    options = {
      internal = mkOption {
        type = types.bool;
        default = false;
        description = "Whether this subcommand is for internal use only. ie not displayed in the help menu";
      };

      description = mkOption {
        type = types.str;
        description = "Description of the subcommand";
      };

      command = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Base command to execute";
        apply = str:
          if str == null
          then null
          else lib.strings.trim str;
      };

      args = mkOption {
        type = types.listOf types.str;
        description = "Arguments to pass to the command";
        example = ["--model" "gemini" "--watch-files"];
        apply = list:
          if list == null
          then null
          else map lib.strings.trim list;
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

    internal = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this subcommand is for internal use only. ie not displayed in the help menu";
    };

    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Base command to execute (when no specific subcommand is provided)";
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
