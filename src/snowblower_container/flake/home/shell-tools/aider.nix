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

  cfg = config.snowblower.shell_tools.aider;

in {
  options.snowblower.shell_tools.aider = mkShellTool {
    name = "Aider";
    package = pkgs.aider-chat;
    settings = {
# TODO: add commands here.
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Ruby version
        cfg.package
      ];
  };
}
