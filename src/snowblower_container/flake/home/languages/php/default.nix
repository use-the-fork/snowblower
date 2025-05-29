{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkLanguage;
  inherit (lib) mkOption mkEnableOption mkIf types attrValues getAttrs;

  cfg = config.snowblower.languages.php;
  
  ini = pkgs.formats.ini {};

  filterDefaultExtensions = ext: builtins.length (builtins.filter (inner: inner == ext.extensionName) cfg.settings.disableExtensions) == 0;

  configurePackage = package:
    package.buildEnv {
      extensions = {
        all,
        enabled,
      }:
        with all; (builtins.filter filterDefaultExtensions (enabled ++ attrValues (getAttrs cfg.settings.extensions package.extensions)));
      extraConfig = "";  # We'll use the home-manager generated ini file instead
    };
in {

  imports = [
    ./tools
  ];

  options.snowblower.languages.php = mkLanguage {
    name = "PHP";
    package = pkgs.php83;
    settings = {
      config = mkOption {
        type = types.submodule {freeformType = ini.type;};
        default = {};
        description = "PHP.ini directives as a structured attribute set";
      };

      extensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          PHP extensions to enable.
        '';
      };

      disableExtensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          PHP extensions to disable.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; let
      finalPackage = configurePackage cfg.package;
    in
      [ 
        finalPackage 
      ];

    # PHP configuration
    home.file.".config/php/php.ini" = {
      enable = true;
      source = ini.generate "php-config" cfg.settings.config;
    };
  };
}
