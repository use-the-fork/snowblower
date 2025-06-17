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
      };
    };

    config.snowblower = {
    };
  });
}
