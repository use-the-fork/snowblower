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
        inputs.snow-blower.flakeModules.optionsDocument
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        # IE. You dont have to do `inputs.flake-parts.YOURSYSTEM.package` you can just do `inputs'.flake-parts.package`

        imports = [
          # ./foo.nix
        ];

        snow-blower = {
            #the root of this flake is actually 2 directories back.
            paths.src = ./../../.;

            languages = {
              php.enable = true;
            };

            ai.laravel.enable = true;
            ai.nix.enable = true;

            scripts = {
              "reload" = {
                just.enable = true;
                description = "reloads snow blower.";
                exec = ''
                  direnv reload
                '';
              };
            };

            integrations = {
              agenix = {
                enable = true;
                secrets = {
                  "foo" = {
                    file = "secrets/foo.age";
                    publicKeys = [
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH"
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOSE69dmDxQ/UJ8k+8CL3lzc/PyJXXO/2aCcYQOjkTW+ sincore@sushi"
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
}
