topLevel @ {
  inputs,
  lib,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.templates = flakeModule: {
    imports = [

    ];

flake = {
        templates =
          let
            base = {
              path = ./templates/flake-parts;
              description = "The base snow blower flake.";
            };

          in
          {
            inherit base;
            default = base;
          };
};

  };
}
