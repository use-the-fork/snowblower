topLevel@{ inputs, flake-parts-lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ../../common.nix
  ];
  flake.flakeModules.integrations-tree-fmt = {
    imports = [
      topLevel.config.flake.flakeModules.common
      topLevel.config.flake.flakeModules.integrations-just
      topLevel.config.flake.flakeModules.integrations-git-hooks
    ];

    options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, pkgs, config, ... }: let
     inherit (lib) types mkOption;

    in {

      options.snow-blower.treefmt = mkOption {
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

        #automatically add treefmt-nix to pre-commit if the user enables it.
        git-hooks.hooks.treefmt.package = config.snow-blower.treefmt.build.wrapper;

        #automatically add treefmt-nix to just.
        just.recipes.treefmt = {
                   package = lib.mkDefault config.snow-blower.treefmt.build.wrapper;
                   justfile = lib.mkDefault ''
                     # Auto-format the source tree using treefmt
                     fmt:
                       ${lib.getExe config.snow-blower.just.recipes.treefmt.package}
                   '';
                 };

        shell = {
              packages = [
                config.snow-blower.treefmt.build.wrapper
              ];
        };
      };

    });

  };
}
