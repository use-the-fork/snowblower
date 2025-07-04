{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkIntegration mkOption types;

    yamlFormat = pkgs.formats.yaml {};
    cfg = config.snowblower.integration.convco;
    inherit (config.snowblower.command."convco") exec;
  in {
    options.snowblower.integration.convco = mkIntegration {
      name = "Convco";
      package = pkgs.convco;
      extraOptions = {
        fileName = mkOption {
          type = types.str;
          description = "The name of the file to output the chaneglog to.";
          default = "CHANGELOG.md";
        };
      };
    };

    config.snowblower = lib.mkIf cfg.enable {
      integration.just.recipe."convco" = {
        enable = true;
        description = "Conventional commit cli";
        exec = "changelog > ${cfg.settings.fileName}";
      };

      packages.tools = [
        cfg.package
      ];

      file.".versionrc" = {
        enable = true;
        source = yamlFormat.generate ".versionrc" cfg.settings.config;
      };
    };
  });
}
