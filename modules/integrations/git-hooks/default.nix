{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.git-hooks.flakeModule
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      self',
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption;
      cfg = config.snow-blower.integrations.git-hooks;
    in {
      options.snow-blower.integrations.git-hooks = lib.mkOption {
        type = lib.types.submoduleWith {
          modules = [
            (inputs.git-hooks + "/modules/hooks.nix")
            (inputs.git-hooks + "/modules/all-modules.nix")
            {
              rootSrc = self';
              package = pkgs.pre-commit;
              tools = import (inputs.git-hooks + "/nix/call-tools.nix") pkgs;
            }
          ];
          specialArgs = {inherit pkgs;};
          shorthandOnlyDefinesConfig = true;
        };
        default = {};
        description = "Integration of https://github.com/cachix/git-hooks.nix";
      };

      config.snow-blower = {
        packages = lib.mkAfter ([cfg.package] ++ (cfg.enabledPackages or []));
        shell = {
          startup = [cfg.installationScript];
        };
      };
    });
  };
}
