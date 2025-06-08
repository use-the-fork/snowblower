{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ./files.nix
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
        build = mkOption {
          type = types.package;
          description = ''
            The generated snowblower package.
          '';
          default = import ./snowblower.nix {
            inherit pkgs lib config;
          };
          internal = true;
        };
      };
    });
  };
}
