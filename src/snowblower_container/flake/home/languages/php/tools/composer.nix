{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.utils) mkLanguageTool;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  cfg = config.snowblower.languages.php.tools.composer;

in {
  options.snowblower.languages.php.tools.composer = mkLanguageTool {
    name = "Composer";
    package = pkgs.php83Packages.composer;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [cfg.package];

    # Create composer directory
    home.activation.createComposerDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.composer/vendor/bin
    '';

    # Add composer bin to PATH
    home.sessionPath = [
      "$HOME/.composer/vendor/bin"
    ];

  };
}
