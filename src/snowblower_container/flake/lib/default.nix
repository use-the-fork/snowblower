{lib, inputs, self, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

    inherit (import ./shell-tools.nix {inherit lib;}) mkShellTool;
    inherit (import ./language.nix {inherit lib;}) mkLanguage mkLanguageTool;
    inherit (import ./builders.nix {inherit lib inputs self;}) mkHomeConfiguration;
    inherit (import ./utils.nix {inherit lib;}) mkEnableOption';


in {
  flake.utils = {
    inherit mkHomeConfiguration;
    inherit mkShellTool;
    inherit mkLanguage mkLanguageTool;
    inherit mkEnableOption';
  };
}
