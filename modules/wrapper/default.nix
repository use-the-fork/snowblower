{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.wrapper = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) types mkOption;
    in {
      options.snow-blower.wrapper = {
        files = {
          config = mkOption {
            type = types.listOf types.attrs;
            description = "Configuration files to be created by the snowblower script";
            default = [];
            internal = true;
          };
        };

        build = mkOption {
          type = types.package;
          description = ''
            The generated snowblower script.
          '';
          default = import ./wrapper.nix {
            inherit pkgs lib config;
          };
          internal = true;
        };
      };
    });
  };
}
