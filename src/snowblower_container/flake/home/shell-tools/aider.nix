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

  cfg = config.modules.tools.aider;
  
  yamlFormat = pkgs.formats.yaml {};

in {
  options.modules.tools.aider = mkShellTool {
    name = "Aider";
    package = pkgs.aider-chat;
    settings = {

      auto-commits = mkOption {
        description = "Enable/disable auto commit of LLM changes.";
        default = false;
        type = types.bool;
      };

      dirty-commits = mkOption {
        description = "Enable/disable commits when repo is found dirty";
        default = true;
        type = types.bool;
      };

      auto-lint = mkOption {
        description = "Enable/disable automatic linting after changes";
        default = true;
        type = types.bool;
      };

      dark-mode = mkOption {
        description = "Use colors suitable for a dark terminal background.";
        default = true;
        type = types.bool;
      };

      light-mode = mkOption {
        description = "Use colors suitable for a light terminal background";
        default = false;
        type = types.bool;
      };

      cache-prompts = mkOption {
        description = "Enable caching of prompts.";
        default = false;
        type = types.bool;
      };

      code-theme = mkOption {
        description = "Set the markdown code theme";
        default = "default";
        type = types.enum ["default" "monokai" "solarized-dark" "solarized-light"];
      };

      edit-format = mkOption {
        description = "Set the markdown code theme";
        default = "diff";
        type = types.enum ["whole" "diff" "diff-fenced" "udiff"];
      };

      extraConf = mkOption {
        type = types.submodule {freeformType = yamlFormat.type;};
        default = {};
        description = ''
          Extra configuration for aider, see
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

      cfgWithoutExcludedKeys = lib.attrsets.filterAttrs (name: _value: name != "conventions" && name != "extraConf" && name != "port" && name != "host") cfg.settings;
      cfgWithExtraConf = lib.attrsets.recursiveUpdate cfgWithoutExcludedKeys (cfg.settings.extraConf
        // {
          check-update = false;
        });

    in {
      enable = true;
      source = yamlFormat.generate "aider-conf" cfgWithExtraConf;
    };


  };
}
