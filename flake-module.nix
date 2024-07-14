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
            Project-level Snow Blower configuration

            Use `config.snow-blower.build.devShell` to get access to the resulting devShell
            package based on this configuration.

            By default snow-blower will set the `devShell.<system>` attribute of the flake,
            used by the `nix develop` command.
          '';
          type = types.submoduleWith {
            modules = (import ./.).submodule-modules ++ [{
              options.flakeShell = lib.mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Enables `Snow Blower` as the default devShell used by the `nix develop` command
                '';
              };
#              FIXME: Can we make this work somehow?
#              options.flakeCheck = lib.mkOption {
#                type = types.bool;
#                default = true;
#                description = ''
#                  Add a flake check to run `treefmt`
#                '';
#              };
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
#          checks = lib.mkIf config.snow-blower.flakeCheck { snow-blower = config.snow-blower.build.check config.snow-blower.projectRoot; };
          devShell = lib.mkIf config.snow-blower.flakeShell (lib.mkDefault config.snow-blower.build.devShell);
        };
      });
  };
}
