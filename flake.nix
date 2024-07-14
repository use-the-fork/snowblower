{
  description = "snow-blower";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, lib, ... }:
      let


      in {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
        perSystem = { config, self', inputs', pkgs, system, ... }: {

          devShells.default = self'.checks.self-shell;

          checks = (import ./checks {
            inherit inputs;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config = {
                # required for packer
                allowUnfree = true;
              };
            };
            snow-blower = self.lib;
          });

          packages = {
            docs = self'.checks.module-docs;
          };

        };

        flake = {
          flakeModule = ./flake-module.nix;
          lib = import ./.;
        };
      });
}
