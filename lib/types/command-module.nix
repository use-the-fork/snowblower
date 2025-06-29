{lib, ...}: let
  inherit (lib) types mkOption;

  shortcutModule = {
    options = {
      internal = mkOption {
        type = types.bool;
        default = false;
        description = "Whether this shortcut is for internal use only. ie not displayed in the help menu";
      };

      description = mkOption {
        type = types.str;
        description = "Description of the shortcut";
      };

      env = mkOption {
        type = types.nullOr (types.enum ["native" "tools" "runtime" "service"]);
        default = null;
        description = "Environment context for the command execution";
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

  shortcutType = types.submodule shortcutModule;
in {
  options = {
    displayName = mkOption {
      type = types.str;
      description = "Display name of the command (e.g., 'NPM' for npm, 'SnowBlower' for snow)";
    };

    env = mkOption {
      type = types.enum ["native" "tools" "runtime" "service"];
      default = "native";
      description = "Environment context for the command execution";
    };

    internal = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this subcommand is for internal use only. ie not displayed in the help menu";
    };

    command = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Base command to execute.";
      apply = str:
        if str == null
        then null
        else lib.strings.trim str;
    };

    description = mkOption {
      type = types.str;
      description = "Description of the command";
    };

    shortcut = mkOption {
      type = lib.sbl.types.dagOf shortcutType;
      default = {};
      description = "Shortcut available for this command";
    };
  };
}
