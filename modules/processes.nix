topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.processes = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;

    in {

      config.snow-blower = lib.mkIf (config.process-compose.watch-server.settings.processes != {}) {

        just.recipes.up = {
          enable = lib.mkDefault true;
          justfile = lib.mkDefault ''
            # Starts the environment.
            up:
              nix run .#watch-server
          '';
        };
      };
    });
  };
}
