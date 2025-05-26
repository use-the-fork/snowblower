{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkLanguage;
  inherit (lib) mkOption mkEnableOption mkIf types attrValues getAttrs;

  cfg = config.modules.languages.php;
  
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
  options.modules.languages.php = mkLanguage {
    name = "PHP";
    package = pkgs.php83;
    settings = {
      composer = {
        enable = mkEnableOption "Whether to enable Composer package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.php83Packages.composer;
          description = "Composer package to use";
        };
      };

      ini = mkOption {
        type = ini.type;
        default = {
          PHP = {
            display_errors = "On";
            error_reporting = "E_ALL";
            memory_limit = "512M";
            max_execution_time = "120";
            "date.timezone" = "UTC";
          };
          opcache = {
            "opcache.enable" = "1";
            "opcache.memory_consumption" = "128";
            "opcache.interned_strings_buffer" = "8";
            "opcache.max_accelerated_files" = "4000";
            "opcache.validate_timestamps" = "1";
            "opcache.revalidate_freq" = "2";
          };
        };
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
        # Always include the configured PHP version
        finalPackage
      ]
      # Add composer if enabled
      ++ lib.optional cfg.settings.composer.enable cfg.settings.composer.package;

    # Create composer directory
    home.activation.createComposerDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.composer/vendor/bin
    '';

    # Add composer bin to PATH
    home.sessionPath = [
      "$HOME/.composer/vendor/bin"
    ];

    # PHP configuration
    home.file.".config/php/php.ini" = {
      enable = true;
      source = ini.generate "php-config" cfg.settings.ini;
    };
  };
}
