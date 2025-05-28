{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkShellTool;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.snowblower.tools.aider;
  
  yamlFormat = pkgs.formats.yaml {};

in {
  options.snowblower.tools.aider = mkShellTool {
    name = "Aider";
    package = pkgs.aider-chat;
    settings = {
      config = mkOption {
        type = types.submodule {freeformType = yamlFormat.type;};
        default = {};
        description = ''
          Configuration for aider, see
          <link xlink:href="See settings here: https://aider.chat/docs/config/aider_conf.html"/>
          for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Ruby version
        cfg.package
      ];

    home.file.".aider.conf.yml" = let 

      # cfgWithExtraConf = lib.attrsets.recursiveUpdate (
        # // {
        #   check-update = false;
        # });

    in {
      enable = true;
      source = yamlFormat.generate "aider-conf" cfg.settings.config;
    };


  };
}
