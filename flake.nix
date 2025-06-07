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

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }: let
    src = ./.;
    #
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
          ./packages/flake/modules
          ./packages/flake/lib
        ];
        debug = true;
        systems = import inputs.systems;
      });

    mkSnowBlower = import ./packages/flake/mkSnowBlower.nix {inherit inputs self;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        bootstrap.flakeModules.default
        # ./options-document.nix
      ];

      flake =
        bootstrap
        // {
          templates = let
            base = {
              path = ./packages/flake/templates/base;
              description = "The base snow blower flake.";
            };
          in {
            inherit base;
            default = base;

            ruby = {
              path = ./packages/flake/templates/ruby;
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
              path = ./packages/flake/templates/laravel;
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
