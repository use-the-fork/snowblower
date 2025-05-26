{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.modules.user = {
    username = mkOption {
      type = types.str;
      description = "The username for configuration";
      default = "code";
    };

    email = mkOption {
      type = types.str;
      description = "The email address for configuration";
      default = "";
    };
  };
}
