{lib, ...}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options = {
    enable = mkEnableOption "this recipe";
    justfile = mkOption {
      type = types.str;
      description = ''
        The justfile representing this recipe.
      '';
    };
  };
}
