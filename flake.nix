{
  description = "snow-blower";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, lib, ... }:
    {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

#          formatter = self'.checks.self-wrapper;

          checks = (import ./checks {
            pkgs = import inputs.nixpkgs {
              inherit system;
              config = {
                # required for packer
                allowUnfree = true;
              };
            };
            snow-blower = self.lib;
          });
      };

      flake = {
        flakeModule = ./flake-module.nix;
        lib = import ./.;
      };
    });
}

#
## flake.nix "flake" "imports"
#{
#  inputs = {
#    nixpkgs.url = "nixpkgs";
#
#    flake-parts = {
#      url = "github:hercules-ci/flake-parts";
#      inputs.nixpkgs-lib.follows = "nixpkgs";
#    };
#
#  };
#
#  outputs = inputs@{ self, nixpkgs, flake-parts }: flake-parts.lib.mkFlake { inherit inputs; } {
#    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
#
#    imports = [];
#
#    flake = {
#      # your existing definitions before using flake-parts...
#    };
#  };
#}
