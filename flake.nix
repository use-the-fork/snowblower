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
    flake-parts.lib.mkFlake { inherit inputs; } (_:
      {
        flake.flakeModule = {
          imports = [
            ./modules
          ];
        };

        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
        perSystem = { config, pkgs, system, ... }:
          let

            lib = import ./.;

            sbChecks = import ./checks {
              inherit inputs;
              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {
                  # required for packer
                  allowUnfree = true;
                };
              };
              snow-blower = lib;
            };

          in
          {

            devShells.default = sbChecks.self-shell;

          };

      });
}
