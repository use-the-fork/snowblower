{
  description = "snow-blower";

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    flake-root.url = "github:srid/flake-root";

    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix.url = "github:ryantm/agenix";
  };

  nixConfig = {
    accept-flake-config = true;
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://cache.garnix.io"
    ];
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }: let
    coreInputs =
      inputs
      // {
        src = ./.;
      };

    src = ./.;

    bootstrap =
      inputs.flake-parts.lib.mkFlake {
        inherit inputs self;
        moduleLocation = ./flake.nix;
      } ({...}: {
        imports = [
          {
            _module.args = {
              inherit src;
            };
          }
          ./modules
          ./modules/options-document.nix
        ];
        debug = true;
        systems = import inputs.systems;
      });
    mkSnowBlower = import ./mkSnowBlower.nix {inherit coreInputs;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        bootstrap.flakeModules.default
        bootstrap.flakeModules.optionsDocument
      ];

      flake =
        bootstrap
        // {
          templates = let
            base = {
              path = ./templates/flake-parts;
              description = "The base snow blower flake.";
            };
          in {
            inherit base;
            default = base;
          };
        }
        // {
          inherit mkSnowBlower;
        };
    });
}
