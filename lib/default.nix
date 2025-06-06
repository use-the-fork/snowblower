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
  inherit (import ./utils.nix {inherit lib;}) mkEnableOption';
in {
  flake.utils = {
    inherit mkEnableOption';
    inherit mkDockerService mkIntegration;
  };
}
