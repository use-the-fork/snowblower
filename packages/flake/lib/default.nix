{
  lib,
  inputs,
  self,
  ...
}: let
  inherit
    (import ./module-builders.nix {
      inherit lib;
      pkgs = inputs.nixpkgs.legacyPackages.${self.system};
    })
    mkDockerService
    mkIntegration
    ;

  inherit
    (import ./code-quality/mkCodeQualityTool.nix {
      inherit lib;
      pkgs = inputs.nixpkgs.legacyPackages.${self.system};
    })
    mkCodeQualityTool
    ;

  inherit (import ./code-quality/mkCodeQualityCommand.nix {inherit lib;}) mkCodeQualityCommand;

  inherit (import ./utils.nix {inherit lib;}) mkEnableOption';
  inherit (import ./mkCmdArgs.nix {inherit lib;}) mkCmdArgs;
  inherit (import ./mkConfigFile.nix {inherit lib;}) mkConfigFile;

  inherit (import ./mkLanguage.nix {inherit lib;}) mkLanguage;
in {
  flake.utils = {
    inherit mkEnableOption';
    inherit mkCmdArgs;
    inherit mkDockerService mkIntegration;
    inherit mkCodeQualityTool mkCodeQualityCommand;
    inherit mkConfigFile;
    inherit mkLanguage;
  };
}
