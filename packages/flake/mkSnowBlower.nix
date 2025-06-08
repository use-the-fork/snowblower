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
        snowblower =
          # If snowblower is a function, call it with pkgs
          if builtins.isFunction userArgs.snowblower or null
          then userArgs.snowblower {inherit pkgs inputs self inputs' self';}
          else userArgs.snowblower or {};

        # Pass all other user arguments to perSystem
        _module.args = builtins.removeAttrs userArgs ["snowblower"];
      };
    });
in
  mkSnowBlower
