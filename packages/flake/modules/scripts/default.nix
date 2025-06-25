{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.scripts = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

      scriptType = types.submodule (
        {
          config,
          name,
          ...
        }: {
          options = {
            exec = lib.mkOption {
              type = types.str;
              description = "Shell code to execute when the script is run.";
            };
            package = lib.mkOption {
              type = types.package;
              description = "The package to use to run the script.";
              default = pkgs.bash;
              defaultText = lib.literalExpression "pkgs.bash";
            };
            description = lib.mkOption {
              type = types.str;
              description = "Description of the script.";
              default = "";
            };
            just = {
              enable = lib.mkOption {
                type = types.bool;
                description = "Include this script in just runner.";
                default = false;
              };
            };
            scriptPackage = lib.mkOption {
              internal = true;
              type = types.package;
            };
          };

          config.scriptPackage = lib.hiPrioSet (
            pkgs.writeScriptBin name ''
              #!${pkgs.lib.getExe config.package}
              ${config.exec}
            ''
          );
        }
      );
    in {
      options.snowblower.scripts = lib.mkOption {
        type = types.attrsOf scriptType;
        default = {};
        description = "A set of scripts available when the environment is active.";
      };

      config.snowblower = {
        packages = lib.mapAttrsToList (_: script: script.scriptPackage) config.snowblower.scripts;

        just = {
          recipes = lib.genAttrs (builtins.attrNames config.snowblower.scripts) (name: let
            script = config.snowblower.scripts.${name};
          in {
            enable = lib.mkDefault script.just.enable;
            justfile = lib.mkDefault ''
              #${script.description}
              ${name}:
                ${name}
            '';
          });
        };
      };
    });
  };
}
