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

  cfg = config.snowblower.languages.python.tools.uv;

  toml = pkgs.formats.toml {};

in {
  options.snowblower.languages.python.tools.uv = mkLanguageTool {
    name = "UV";
    package = pkgs.uv;
    settingType = toml.type;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [cfg.package];

    # Configure uv
    home.file.".config/uv/config.toml" = {
      enable = true;
      source = toml.generate "uv-config" cfg.settings;
    };

  };
}
