{ lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mkOption types;
in
{
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }: {
      options.snow-blowers = mkOption {
        description = ''
          Configure devshells with flake-parts.

          These are then consumed by `devShells`, with a capital S.

          Each snow-blower will also configure an equivalent `devShells`.

          Used to define snow-blowers.
        '';

        type = types.lazyAttrsOf (types.submoduleWith {
          modules = import ./modules/modules.nix { inherit pkgs lib; };
        });
        default = { };
      };
      config.devShells = lib.mapAttrs (_name: devshell: devshell.devshell.shell) config.devshells;
    });
  };
}
