_: let
  mkSnowBlower = {
    inputs,
    imports ? [],
    perSystem ? {},
    snow-blower ? {},
    ...
  }:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports =
        [
          inputs.snow-blower.flakeModule
        ]
        ++ imports;

      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      inherit perSystem;
    };
in
  mkSnowBlower
