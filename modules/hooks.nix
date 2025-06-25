{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
  in {
    imports = [
    ];

    options.snowblower = {
      hook = {
        switch = {
          activation = mkOption {
            type = lib.sbl.types.dagOf types.str;
            default = {};
            description = ''
            '';
          };
        };
        shell = {
          activation = mkOption {
            type = lib.sbl.types.dagOf types.str;
            default = {};
            description = ''

            '';
          };
        };
      };

      hookSwitchActivationPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          Foo
        '';
      };
    };

    config.snowblower = {
      hookSwitchActivationPackage = let
        resolvedHooks = lib.concatStringsSep "\n" (
          map (section: section.name)
          (lib.sbl.dag.resolveDag {
            name = "snowblower command options";
            dag = config.snowblower.command;
            mapResult = lib.id;
          })
        );
      in
        pkgs.writeTextFile {
          name = "hook-switch-activation.sh";
          text = ''
            ${resolvedHooks}
          '';
        };
    };
  });
}
