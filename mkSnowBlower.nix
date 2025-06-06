args @ {
  inputs,
  self,
  ...
}: let
  mkSnowBlower = userArgs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      systems = import inputs.systems;
      imports = [
        self.flakeModule
      ];
      perSystem = {
        pkgs,
        inputs,
        self,
        inputs',
        self',
        ...
      }: {
        snow-blower =
          # If snow-blower is a function, call it with pkgs
          if builtins.isFunction userArgs.snow-blower or null
          then userArgs.snow-blower {inherit pkgs inputs self inputs' self';}
          else userArgs.snow-blower or {};

        # Pass all other user arguments to perSystem
        _module.args = builtins.removeAttrs userArgs ["snow-blower"];
      };
    });
in
  mkSnowBlower
