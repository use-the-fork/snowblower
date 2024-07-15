topLevel@{ inputs, flake-parts-lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ../../common.nix
  ];
  flake.flakeModules.tree-fmt = {
    imports = [
      topLevel.config.flake.flakeModules.common
      topLevel.config.flake.flakeModules.integrations-just
    ];

    options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, pkgs, config, ... }: let
     inherit (lib) types mkOption;

    in {

      options.snow-blower.tree-fmt = mkOption {
                         type = types.submoduleWith {
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


      config.snow-blower = {
        shell = {
              packages = [
                config.snow-blower.treefmt.build.wrapper
              ];
        };
      };

    });

  };
}
