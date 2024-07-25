{...}: let

mkSnowBlower = flakeOptions @ {
    inputs,
    src,
    perSystem,
    snow-blower ? {},
    ...
  }: let
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
       imports = [
          inputs.snow-blower.flakeModule
        ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      inherit perSystem;
    };

in  mkSnowBlower
