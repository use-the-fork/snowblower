{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
  in {
    options.snowblower = {
      env = mkOption {
        description = "Attribute set of environment variables that will be set in the environment.";
        default = {};
        type = types.attrsOf types.str;
      };
    };

    config = {
      snowblower = {
        env = {
          "PROJECT_ROOT" = toString config.snowblower.paths.root;
          "PROJECT_DOTFILE" = toString config.snowblower.paths.snowblowerDir;

          "PROJECT_PROFILE" = toString config.snowblower.paths.profile;
          "PROJECT_STATE" = toString config.snowblower.paths.state;
          "PROJECT_RUNTIME" = toString config.snowblower.paths.runtime;
        };
      };
    };
  });
}
