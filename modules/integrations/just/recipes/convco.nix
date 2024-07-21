{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      pkgs,
      config,
      lib,
      ...
    }: let
      inherit (lib) mkIf mkOption types;
      inherit (self.lib.sb) mkJustRecipe;

      cfg = config.snow-blower.just.recipes.convco;
    in {
      options.snow-blower.just.recipes.convco = mkJustRecipe {
                    name = "Convco";
                    package = pkgs.convco;
                    settings = {
                                       file-name =
                                         mkOption {
                                           type = types.str;
                                           description = lib.mdDoc "The name of the file to output the chaneglog to.";
                                           default = "CHANGELOG.md";
                                         };
                                     };
                };

      config.snow-blower.just.features.convco = mkIf cfg.enable {
                 enable = true;
                 justfile =
                   let
                     binPath = lib.getExe cfg.package;
                     fileName = cfg.settings.file-name;
                   in
                   lib.mkDefault ''
                     # Generate ${fileName} using recent commits
                     changelog:
                       ${binPath} changelog -p "" > ${fileName}
                   '';
               };
    });
  };
}
