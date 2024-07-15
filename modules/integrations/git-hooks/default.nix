topLevel@{ inputs, flake-parts-lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    ../../common.nix
  ];
  flake.flakeModules.integrations-git-hooks = {
    imports = [
      topLevel.config.flake.flakeModules.common
      topLevel.config.flake.flakeModules.integrations-just
    ];

    options.perSystem = flake-parts-lib.mkPerSystemOption ({ self, lib, pkgs, config, ... }: let
     inherit (lib) types mkOption;

    in {

      options.snow-blower.git-hooks = lib.mkOption {
                              type = lib.types.submoduleWith {
                                modules = [
                                  (inputs.git-hooks + "/modules/all-modules.nix")
                                  {
                                    rootSrc = self;
                                    package = pkgs.pre-commit;
                                    tools = import (inputs.git-hooks + "/nix/call-tools.nix") pkgs;
                                  }
                                ];
                                specialArgs = { inherit pkgs; };
                                shorthandOnlyDefinesConfig = true;
                              };
                              default = { };
                              description = "Integration of https://github.com/cachix/pre-commit-hooks.nix";
                            };


      config.snow-blower = {
        shell = {
            packages = lib.mkAfter ([ config.snow-blower.git-hooks.package ] ++ (config.snow-blower.git-hooks.enabledPackages or [ ]));
            shellPreHook = config.snow-blower.git-hooks.installationScript;
        };
      };

    });

  };
}
