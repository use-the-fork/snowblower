topLevel@{ inputs, lib, flake-parts-lib, ... }: {

  imports = [
    ./shell.nix
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.optionsDocument = flakeModule: {
    imports = [
      topLevel.config.flake.flakeModules.shell
    ];
    options.perSystem = flake-parts-lib.mkPerSystemOption (
      perSystem@{ pkgs, system, inputs', self', ... }:
      let

      in
      {
        snow-blower = {

          just.recipes.treefmt.enable = true;

          git-hooks.hooks = {
              treefmt = {
                enable = true;
              };
          };
        };
      }
    );
  };
}
