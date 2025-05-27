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

  cfg = config.snowblower.languages.python.tools.ruff;

  toml = pkgs.formats.toml {};

in {
  options.snowblower.languages.python.tools.ruff = mkLanguageTool {
    name = "Ruff";
    package = pkgs.ruff;
    settingType = toml.type;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [cfg.package];

    home.file.".config/ruff/ruff.toml" = {
      enable = true;
      source = toml.generate "ruff-config" cfg.settings;
    };

  };
}
