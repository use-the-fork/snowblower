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
            };
            binary = lib.mkOption {
              type = types.str;
              description = "Override the binary name if it doesn't match package name";
              default = config.package.pname;
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
                default = true;
              };
            };
            scriptPackage = lib.mkOption {
              internal = true;
              type = types.package;
            };
          };

          config.scriptPackage = lib.hiPrioSet (
            pkgs.writeScriptBin name ''
              #!${pkgs.lib.getBin config.package}/bin/${config.binary}
              ${config.exec}
            ''
          );
        }
      );
    in {
      options.snow-blower.scripts = lib.mkOption {
        type = types.attrsOf scriptType;
        default = {};
        description = "A set of scripts available when the environment is active.";
      };

      config.snow-blower = {
        packages = lib.mapAttrsToList (_: script: script.scriptPackage) config.snow-blower.scripts;
      };
    });
  };
}
