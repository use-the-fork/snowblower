{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  sbLib = self: {
    extendedLib = {
      # Module builders and utilities for the custom module structure found in this
      # repository.
      modules = import ./modules.nix lib;
    };

    # Get individual functions from the parent attributes
    inherit (self.extendedLib.modules) mkService;
  };
in {
  inherit sbLib;
}
