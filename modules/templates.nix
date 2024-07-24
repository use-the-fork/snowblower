{
  inputs,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.templates = _flakeModule: {
    imports = [
    ];

    flake = {
      templates = let
        base = {
          path = ./templates/flake-parts;
          description = "The base snow blower flake.";
        };
      in {
        inherit base;
        default = base;
      };
    };
  };
}
