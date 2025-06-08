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
          type = types.listOf types.attrs;
          description = "Files to be created by SnowBlower";
          default = [];
          internal = true;
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
            ${lib.concatStringsSep "\n" (map (file: ''
                cp -f ${builtins.toString (file.format.generate file.name file.settings)} ./${file.name}
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
