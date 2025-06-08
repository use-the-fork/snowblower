{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.core = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) types mkOption;
    in {
      options.snowblower.core = {
        files = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
                description = "Whether to enable this file";
              };
              format = mkOption {
                type = types.attrs;
                description = "Format generator to use for this file";
              };
              settings = mkOption {
                type = types.anything;
                description = "Settings to pass to the format generator";
                default = {};
              };
            };
          });
          description = "Files to be created by SnowBlower";
          default = {};
        };

        packages.files = mkOption {
          type = types.package;
          internal = true;
          description = "Package to contain and generate all files";
        };
      };

      config = {
        snowblower.core.packages.files = pkgs.writeShellApplication {
          name = "snowblower-files";
          runtimeInputs = [];
          text = ''
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: file: ''
                ${lib.optionalString file.enable ''
                  mkdir -p "$(dirname ./${name})"
                  cp -f ${builtins.toString (file.format.generate name file.settings)} ./${name}
                ''}
              '')
              config.snowblower.core.files)}
          '';
        };

        packages = {
          "snowblower-files" = config.snowblower.core.packages.files;
        };
      };
    });
  };
}
