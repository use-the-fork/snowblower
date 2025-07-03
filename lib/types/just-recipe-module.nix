{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable this recipe";
    };

    description = mkOption {
      type = types.str;
      description = "Description of the recipe";
    };

    exec = mkOption {
      type = types.either types.str (types.listOf types.str);
      default = null;
      description = "Recipe command to run in the container";
      apply = value:
        if value == null
        then null
        else if builtins.isString value
        then lib.strings.trim value
        else lib.strings.trim (lib.concatStringsSep "\n" value);
    };
  };
}
