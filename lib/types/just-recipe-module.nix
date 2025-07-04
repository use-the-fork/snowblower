{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable this recipe";
    };

    group = mkOption {
      type = types.str;
      description = "Group or category that this recipe belongs to";
    };

    description = mkOption {
      type = types.str;
      description = "Description of the recipe";
    };

    printCommand = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to print the command before executing it";
    };

    positionalArguments = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this recipe accepts positional arguments";
    };

    private = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this recipe is private (hidden from recipe listings)";
    };

    parameters = mkOption {
      type = types.listOf types.str;
      description = "parameters to pass to the just recipe";
      example = ["model" "gemini"];
      default = [];
      apply = list:
        if list == null
        then null
        else map lib.strings.trim list;
    };

    exec = mkOption {
      type = types.either types.str (types.listOf types.str);
      default = null;
      description = "Recipe command to run in the container";
      apply = value:
        if value == null
        then null
        else if builtins.isString value
        then lib.concatMapStringsSep "\n" (line: "\t" + line) (lib.splitString "\n" (lib.strings.trim value))
        else lib.concatMapStringsSep "\n" (line: "\t" + line) (lib.splitString "\n" (lib.strings.trim (lib.concatStringsSep "\n" value)));
    };
  };
}
