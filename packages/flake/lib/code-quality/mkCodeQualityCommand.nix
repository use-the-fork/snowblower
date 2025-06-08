{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit
    (lib.types)
    nullOr
    listOf
    str
    bool
    int
    ;

  mkCodeQualityCommand = {
    command,
    enable ? false,
    args ? [],
    priority ? 0,
  }: {
    enable = mkOption {
      type = lib.types.bool;
      description = "Enable ${command}";
      default = enable;
    };
    args = mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Arguments to pass to the command";
      default = args;
    };
    priority = lib.mkOption {
      description = "Priority (used to order commands when running treefmt)";
      type = lib.types.nullOr lib.types.int;
      default = priority;
    };

    command = mkOption {
      type = lib.types.str;
      description = "The executable name";
      default = command;
    };
  };
in {
  inherit mkCodeQualityCommand;
}
