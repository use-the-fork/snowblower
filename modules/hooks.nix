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
          boot = mkOption {
            type = lib.sbl.types.dagOf types.str;
            default = {};
            description = ''
              A dag of `bash` strings that run each time a snowblower enters the docker environment.
            '';
          };
        };
      };
    };

    config.snowblower = {
    };
  });
}
