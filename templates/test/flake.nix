{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    snow-blower.url = "github:use-the-fork/snow-blower";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      inherit inputs;

      imports = [
        #        inputs.snow-blower.flakeModules.optionsDocument
      ];

      perSystem = {...}: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        # IE. You dont have to do `inputs.flake-parts.YOURSYSTEM.package` you can just do `inputs'.flake-parts.package`

        imports = [
          # ./foo.nix
        ];
        snow-blower = {
          paths.src = ./../../.;
          dotenv.enable = true;
          packages = [
          ];

          languages = {
            javascript.enable = true;
            javascript.npm.enable = true;
          };

          scripts = {
            "reload" = {
              just.enable = true;
              description = "reloads snow blower.";
              exec = ''
                direnv reload
              '';
            };
          };

          services = {
          };

          integrations = {
            
            aider = {
              enable = true;
              commands = {
                start = {
                  watchFiles = true;
                  suggestShellCommands = false;
                  readFiles = ["CONVENTIONS.MD"];
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

            git-cliff.enable = true;

            treefmt = {
              programs = {
                alejandra.enable = true;
                deadnix.enable = true;
                statix = {
                  enable = true;
                  disabled-lints = [
                    "manual_inherit_from"
                  ];
                };
              };
            };

            git-hooks.hooks = {
              treefmt = {
                enable = true;
              };
            };
          };
        };
      };
    };

  nixConfig = {
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "snow-blower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://snow-blower.cachix.org"
    ];
  };
}
