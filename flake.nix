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

    flake-parts-website.url = "github:hercules-ci/flake.parts-website";

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
      "snow-blower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://snow-blower.cachix.org"
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
        ];
        debug = true;
        systems = import inputs.systems;
      });
    mkSnowBlower = import ./mkSnowBlower.nix {inherit coreInputs;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        bootstrap.flakeModules.default
       ./options-document.nix
      ];

      flake =
        bootstrap
        // {
          templates = let
            base = {
              path = ./templates/base;
              description = "The base snow blower flake.";
            };
          in {
            inherit base;
            default = base;

            ruby = {
              path = ./templates/ruby;
              description = "A simple Ruby project";
              welcomeText = ''
                # Simple Ruby Project Template
                ## Intended usage
                The intended usage of this flake is to provide a starting point for Ruby projects using Nix flakes.

                ## More info
                - [Ruby language](https://www.ruby-lang.org/)
                - [Ruby on the NixOS Wiki](https://wiki.nixos.org/wiki/Ruby)
                - ...
              '';
            };
            laravel = {
              path = ./templates/laravel;
              description = "A simple Laravel project";
              welcomeText = ''
                # Simple Laravel Project Template
                ## Intended usage
                The intended usage of this flake is to provide a starting point for Laravel projects using Nix flakes.

                ## More info
                - [Laravel framework](https://laravel.com/)
                - [Laravel on the NixOS Wiki](https://wiki.nixos.org/wiki/Laravel)
                - ...
              '';
            };
          };
        }
        // {
          inherit mkSnowBlower;
        };
    });
}
