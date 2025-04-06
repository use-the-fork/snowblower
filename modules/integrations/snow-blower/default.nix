{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption mkIf;

    in {

      config.snow-blower = {
        # snow-blower utility just commands
        just.recipes.bump-snow-blower = {
          enable = lib.mkDefault true;
          justfile = lib.mkDefault ''
            # update flake inputs commit flake lock.
            bump:
              nix flake update && git commit flake.lock -m "flake: bump inputs"
          '';
        };
      };
    });
  };
}
