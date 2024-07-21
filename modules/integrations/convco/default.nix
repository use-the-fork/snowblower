{
  inputs,
  self,
  flake-parts-lib,
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
      inherit (self.lib.sb) mkIntegration;

      cfg = config.snow-blower.integrations.convco;

    in {
      options.snow-blower.integrations.convco = mkIntegration {
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

      config.snow-blower = mkIf cfg.enable {

          packages = [
            cfg.package
          ];

        just.recipes.convco = {
           enable = lib.mkDefault true;
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

      };
    });
  };
}
