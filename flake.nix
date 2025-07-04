{
  description = "SnowBlower";

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
          integration = {
            aider = {
              enable = true;
              commands = {
                son = {
                  description = "using Sonet as base";
                  watchFiles = true;
                  suggestShellCommands = false;
                  readFiles = ["CONVENTIONS.MD"];
                  lintCommands = ["treefmt"];
                };
                gem = {
                  description = "using Gemini as base";
                  model = "gemini";
                  watchFiles = true;
                  suggestShellCommands = false;
                  # readFiles = ["CONVENTIONS.MD"];
                  lintCommands = ["treefmt"];
                };
              };
            };
            agenix = {
              enable = true;
              secrets = {
                ".env.local" = {
                  publicKeys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH"
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSE69dmDxQ/UJ8k+8CL3lzc/PyJXXO/2aCcYQOjkTW+"
                  ];
                };
              };
            };
            preCommit.enable = true;
            treefmt.enable = true;
          };

          shell = {
            atuin.enable = true;
          };

          language.javascript = {
            enable = true;
            npm.enable = true;
          };

          # process."npm-dev" = {
          #   enable = true;
          #   exec = "npm install && npm run docs:dev";
          #   port = {
          #     container = 5173;
          #     host = 5173;
          #   };
          # };

          service = {
          };

          tool = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            shfmt.enable = true;
            keepSorted.enable = true;
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

