{
  description = "SnowBlower";

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

    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }: let
    # We extend the base library with our snowblower functions.
    lib = nixpkgs.lib.extend (l: _: (import ./lib l));
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {inherit lib;};
    } ({
      withSystem,
      flake-parts-lib,
      inputs,
      self,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      flakeModules.default = importApply ./flake-module.nix {inherit withSystem;};

      mkSnow = import ./mkSnow.nix {inherit lib inputs self;};
    in {
      imports = [
        flakeModules.default
      ];
      systems = import inputs.systems;
      perSystem = _: {
        snowblower = {
          integrations.aider = {
            enable = true;
            commands = {
              start = {
                description = "w/ linting, watchfiles, and conventions.";
                watchFiles = true;
                suggestShellCommands = false;
                readFiles = ["CONVENTIONS.MD"];
                lintCommands = ["snow treefmt"];
              };
            };
          };

          languages.javascript = {
            enable = true;
            npm.enable = true;
          };

          process."npm-dev" = {
            enable = true;
            exec = "npm run dev";
            port = {
              container = 5432;
              host = 5432;
            };
          };

          codeQuality = {
            alejandra.enable = true;
            statix.enable = true;
          };
        };
      };
      flake = {
        inherit flakeModules mkSnow;
      };
    });
}
#   outputs = inputs @ {
#     self,
#     flake-parts,
#     ...
#   }: let
#     src = ./.;
#     #
#     bootstrap =
#       inputs.flake-parts.lib.mkFlake {
#         inherit inputs self;
#         moduleLocation = ./flake.nix;
#       } ({...}: {
#         imports = [
#           {
#             _module.args = {
#               inherit src;
#             };import inputs.systems;
#           }
#           ./packages/flake/modules
#           ./packages/flake/lib
#         ];
#         debug = true;
#         systems = import inputs.systems;
#       });
#     mkSnowBlower = import ./packages/flake/mkSnowBlower.nix {inherit inputs self;};
#   in
#     inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
#       imports = [
#         bootstrap.flakeModules.default
#         # ./options-document.nix
#       ];
#       flake =
#         bootstrap
#         // {
#           templates = let
#             base = {
#               path = ./packages/flake/templates/base;
#               description = "The base snow blower flake.";
#             };
#           in {
#             inherit base;
#             default = base;
#             ruby = {
#               path = ./packages/flake/templates/ruby;
#               description = "A simple Ruby project";
#               welcomeText = ''
#                 # Simple Ruby Project Template
#                 ## Intended usage
#                 The intended usage of this flake is to provide a starting point for Ruby projects using Nix flakes.
#                 ## More info
#                 - [Ruby language](https://www.ruby-lang.org/)
#                 - [Ruby on the NixOS Wiki](https://wiki.nixos.org/wiki/Ruby)
#                 - ...
#               '';
#             };
#             laravel = {
#               path = ./packages/flake/templates/laravel;
#               description = "A simple Laravel project";
#               welcomeText = ''
#                 # Simple Laravel Project Template
#                 ## Intended usage
#                 The intended usage of this flake is to provide a starting point for Laravel projects using Nix flakes.
#                 ## More info
#                 - [Laravel framework](https://laravel.com/)
#                 - [Laravel on the NixOS Wiki](https://wiki.nixos.org/wiki/Laravel)
#                 - ...
#               '';
#             };
#           };
#         }
#         // {
#           inherit mkSnowBlower;
#         };
#     });
# }

