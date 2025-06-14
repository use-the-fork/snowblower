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
    description = mkOption {
      type = types.str;
      description = "Description of the command";
    };

    subcommands = mkOption {
      type = lib.sbl.types.dagOf subCommandType;
      default = {};
      description = "Subcommands available for this command";
    };
  };
}
