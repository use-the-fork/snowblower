{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.env = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      ...
    }:
      with lib; let
        # Function to generate the export string from the attribute set
        generateExportString = envAttrs:
          concatStringsSep "\n" (
            mapAttrsToList (name: value: "export ${name}=${value}") envAttrs
          );
      in {
        options.snow-blower = {
          env = lib.mkOption {
            type = types.submoduleWith {
              modules = [
                (_env: {
                  config._module.freeformType = types.lazyAttrsOf types.anything;
                })
              ];
            };
            description = "Environment variables to be exposed inside the developer environment.";
            default = {};
          };
        };

        config.snow-blower = {
          # Default env
          env = {
            "PROJECT_ROOT" = toString config.snow-blower.paths.root;
            "PROJECT_DOTFILE" = toString config.snow-blower.paths.dotfile;

            "PROJECT_PROFILE" = toString config.snow-blower.paths.profile;
            "PROJECT_STATE" = toString config.snow-blower.paths.state;
            "PROJECT_RUNTIME" = toString config.snow-blower.paths.runtime;

            #            # Expose the path to nixpkgs
            #            "NIXPKGS_PATH" = toString pkgs.path;
            #
            #            # This is used by bash-completions to find new completions on demand
            #            "XDG_DATA_DIRS" = ''$DEVSHELL_DIR/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}'';
          };

          shell.startup_env = generateExportString config.snow-blower.env;
        };
      });
  };
}
