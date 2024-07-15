{ flake-parts-lib, lib,... }:
let
 inherit (flake-parts-lib) mkPerSystemOption;

 in {
options = {
    perSystem = mkPerSystemOption ({
      config,
      pkgs,
      inputs,
      ...
    }: {
      options.snow-blower.treefmt = lib.mkOption {
                  type = lib.types.submoduleWith {
                    modules = inputs.treefmt-nix.lib.submodule-modules ++ [
                      {
                        projectRootFile = "flake.nix";
                        package = pkgs.treefmt;
                      }
                    ];
                    specialArgs = { inherit pkgs; };
                    shorthandOnlyDefinesConfig = true;
                  };
                  default = { };
                  description = "Integration of https://github.com/numtide/treefmt-nix";
                };
    });
  };

  config = {
    perSystem = {
      config,
      pkgs,
      ...
    }: {
    snow-blower.treefmt = lib.mkIf ((lib.filterAttrs (_id: value: value.enable) config.snow-blower.treefmt.programs) != { }) {
        packages = [
          config.snow-blower.treefmt.build.wrapper
        ];
        #automatically add treefmt-nix to pre-commit if the user enables it.
  #      pre-commit.hooks.treefmt.package = config.treefmt.build.wrapper;
      };
    };
  };

}
