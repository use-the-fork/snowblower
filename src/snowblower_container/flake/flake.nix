{
  description = "Snow Blower";

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";

    # we build against unstable becuase why not?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      # Systems for which attributes of perSystem will be built. As
      # a rule of thumb, only systems provided by available hosts
      # should go in this list. More systems will increase evaluation
      # duration.
      systems = import inputs.systems;

      imports = [
        ./lib
        ./host.nix
      ];
    };

  nixConfig = {
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "snow-blower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
    ];

    extra-substituters = [
      "https://cache.nixos.org" # funny binary cache
      "https://nix-community.cachix.org" # nix-community cache
      "https://nixpkgs-unfree.cachix.org" # unfree-package cache
      "https://snow-blower.cachix.org" #our own cachix cache
    ];
  };
}
