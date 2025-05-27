{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkLanguage;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.snowblower.languages.ruby;
  
  gemrc = pkgs.formats.yaml {};

in {
  options.snowblower.languages.ruby = mkLanguage {
    name = "Ruby";
    package = pkgs.ruby_3_2;
    settings = {
      bundler = {
        enable = mkEnableOption "Whether to enable Bundler package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.bundler;
          description = "Bundler package to use";
        };
      };

      rails = {
        enable = mkEnableOption "Whether to enable Rails framework";
        package = mkOption {
          type = types.package;
          default = pkgs.rubyPackages_3_2.rails;
          description = "Rails package to use";
        };
      };

      rubocop = {
        enable = mkEnableOption "Whether to enable RuboCop for linting";
        package = mkOption {
          type = types.package;
          default = pkgs.rubyPackages_3_2.rubocop;
          description = "RuboCop package to use";
        };
      };

      gemrc = mkOption {
        type = gemrc.type;
        default = {
          gem = "--no-document";
          benchmark = false;
          verbose = true;
          update_sources = true;
          backtrace = false;
        };
        description = "Ruby gems configuration options";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Ruby version
        cfg.package
      ]
      # Add bundler if enabled
      ++ lib.optional cfg.settings.bundler.enable cfg.settings.bundler.package
      # Add rails if enabled
      ++ lib.optional cfg.settings.rails.enable cfg.settings.rails.package
      # Add rubocop if enabled
      ++ lib.optional cfg.settings.rubocop.enable cfg.settings.rubocop.package;

    # Ruby environment setup
    home.sessionVariables = {
      # Set GEM_HOME to install gems locally
      GEM_HOME = "$HOME/.gem/ruby/${cfg.package.version.major}.${cfg.package.version.minor}.0";
      # Add local gems to PATH
      GEM_PATH = "$HOME/.gem/ruby/${cfg.package.version.major}.${cfg.package.version.minor}.0";
    };

    # Configure gemrc
    home.file.".gemrc" = {
      enable = true;
      source = gemrc.generate "gemrc-config" cfg.settings.gemrc;
    };

    # Create gem directory
    home.activation.createGemDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $GEM_HOME/bin
    '';

    # Add gem bin to PATH
    home.sessionPath = [
      "$GEM_HOME/bin"
    ];

    # Add IRB configuration
    home.file.".irbrc" = {
      enable = true;
      text = ''
        require 'irb/completion'
        require 'irb/ext/save-history'

        IRB.conf[:SAVE_HISTORY] = 1000
        IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
        IRB.conf[:AUTO_INDENT] = true
      '';
    };
  };
}
