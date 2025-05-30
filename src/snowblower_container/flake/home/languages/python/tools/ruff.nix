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
    settings = {
          config = mkOption {
            type = types.submodule {freeformType = toml.type;};
            default = { };
            description = "Specify the configuration for Ruff";
          };
    };
  };
}
