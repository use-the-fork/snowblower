topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    ./shell.nix
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.optionsDocument = _flakeModule: {
    imports = [
      topLevel.config.flake.flakeModules.shell
    ];
    options.perSystem = flake-parts-lib.mkPerSystemOption (
      _: {
        snow-blower = {
          just.recipes.treefmt.enable = true;

          treefmt = {
            programs = {
              alejandra.enable = true;
              deadnix.enable = true;
              statix = {
                enable = true;
                disabled-lints = [
                  "manual_inherit_from"
                ];
              };
            };
          };

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
