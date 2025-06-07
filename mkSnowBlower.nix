{
  inputs,
  self,
  ...
}: userArgs:
inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
  systems = import inputs.systems;
  imports = [
    self.flakeModules.default
  ];
  perSystem = {
    pkgs,
    inputs',
    self',
    ...
  }: {
    snow-blower =
      if builtins.isFunction userArgs.snow-blower or null
      then
        userArgs.snow-blower {
          inherit pkgs;
          # Pass snow-blower's inputs and self
          inherit inputs;
          inherit self;
          inherit inputs';
          inherit self';
          # Make snow-blower packages available
          snowBlowerPackages = self.packages.${pkgs.system} or {};
        }
      else userArgs.snow-blower or {};

    _module.args = builtins.removeAttrs userArgs ["snow-blower"];
  };
})
