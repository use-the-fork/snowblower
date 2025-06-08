{
  inputs,
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
      inherit (import ../utils.nix {inherit lib;}) mkIntegration;

      cfg = config.snowblower.integrations.convco;
    in {
      options.snowblower.integrations.convco = mkIntegration {
        name = "Convco";
        package = pkgs.convco;
        settings = {
          file-name = mkOption {
            type = types.str;
            description = "The name of the file to output the chaneglog to.";
            default = "CHANGELOG.md";
          };
        };
      };

      config.snowblower = mkIf cfg.enable {
        packages = [
          cfg.package
        ];

        just.recipes.convco = {
          enable = lib.mkDefault true;
          justfile = let
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
