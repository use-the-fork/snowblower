{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption mkIf;
      inherit (import ../utils.nix {inherit lib;}) mkEnableOption';

      cfg = config.snow-blower.integrations.treefmt;
    in {
      options.snow-blower.integrations.treefmt = mkOption {
        type = inputs.treefmt-nix.lib.submoduleWith lib {
          modules = [
            {
              options.pkgs = lib.mkOption {
                default = pkgs;
                defaultText = "`pkgs` (module argument of `perSystem`)";
              };

              options.projectRoot = lib.mkOption {
                type = types.path;
                default = self;
                defaultText = lib.literalExpression "self";
                description = ''
                  Path to the root of the project on which treefmt operates
                '';
              };

              options.just.enable = mkEnableOption' "enable just command";
            }
          ];
        };
        default = {};
        description = "Integration of https://github.com/numtide/treefmt-nix";
      };

      config.snow-blower = {
        #automatically add treefmt-nix to just.
        just.recipes.treefmt = mkIf cfg.just.enable {
          enable = lib.mkDefault true;
          justfile = lib.mkDefault ''
            # Auto-format the source tree using treefmt
            fmt:
              ${lib.getExe cfg.build.wrapper}
          '';
        };

        #automatically add treefmt-nix to pre-commit if the user enables it.
        integrations.git-hooks.hooks.treefmt.package = cfg.build.wrapper;

        packages = [
          cfg.build.wrapper
        ];
      };
    });
  };
}
