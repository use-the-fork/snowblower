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

    bootstrap =
      inputs.flake-parts.lib.mkFlake {
        inherit inputs self;
        moduleLocation = ./flake.nix;
      } ({...}: {
        imports = [
          ./modules
          ./modules/options-document.nix
          ./modules/test.nix
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
        bootstrap.flakeModules.test
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
