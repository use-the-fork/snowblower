{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

    inherit (import ./shell-tools.nix {inherit lib;}) mkShellTool;
    inherit (import ./language.nix {inherit lib;}) mkLanguage mkLanguageTool;
    inherit (import ./utils.nix {inherit lib;}) mkEnableOption';


in {
  flake.utils = {
    inherit mkShellTool;
    inherit mkLanguage mkLanguageTool;
    inherit mkEnableOption';
  };
}
