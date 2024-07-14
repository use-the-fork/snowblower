{ self, lib, inputs, ... }:
let
  inherit (inputs.flake-parts.flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
in
{
  options = {
    perSystem = mkPerSystemOption
      ({ config, self', inputs', pkgs, system, ... }: {
        options.snow-blower = mkOption {
          description = ''
            Project-level treefmt configuration

            Use `config.snow-blower.build.wrapper` to get access to the resulting treefmt
            package based on this configuration.

            By default snow-blower will set the `devshell.<system>` attribute of the flake,
            used by the `nix fmt` command.
          '';
          type = types.submoduleWith {
            modules = (import ./.).submodule-modules ++ [{
              options.pkgs = lib.mkOption {
                default = pkgs;
                defaultText = "`pkgs` (module argument of `perSystem`)";
              };
              options.flakeFormatter = lib.mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Enables `treefmt` the default formatter used by the `nix fmt` command
                '';
              };
              options.flakeCheck = lib.mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Add a flake check to run `treefmt`
                '';
              };
              options.projectRoot = lib.mkOption {
                type = types.path;
                default = self;
                defaultText = lib.literalExpression "self";
                description = ''
                  Path to the root of the project on which treefmt operates
                '';
              };

            }];
          };
        };
        config = {
          checks = lib.mkIf config.snow-blower.flakeCheck { snow-blower = config.snow-blower.build.check config.snow-blower.projectRoot; };
          formatter = lib.mkIf config.snow-blower.flakeFormatter (lib.mkDefault config.snow-blower.build.wrapper);
        };
      });
  };
}
