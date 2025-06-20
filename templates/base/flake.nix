{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    snowblower.url = "github:use-the-fork/snowblower";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snowblower.mkSnowBlower {
      inherit inputs;

      imports = [
        inputs.snowblower.flakeModule
      ];

      src = ./.;

      perSystem = {pkgs, ...}: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        # IE. You dont have to do `inputs.flake-parts.YOURSYSTEM.package` you can just do `inputs'.flake-parts.package`

        imports = [
          # ./foo.nix
        ];

        snowblower = {
          integrations = {
            #the options here mirror the offical repo: https://github.com/numtide/treefmt-nix/tree/main
            treefmt = {
              programs = {
                #formater for nix
                alejandra.enable = true;
              };
            };

            # pre-commit hooks
            #the options here mirror the offical repo: https://github.com/cachix/git-hooks.nix
            git-hooks.hooks = {
              treefmt.enable = true;
            };
          };

          scripts = {
            "hi" = {
              just.enable = true;
              description = "runs the hellp command";
              exec = ''
                hello
              '';
            };
          };

          packages = [pkgs.hello];

          shell.startup = [
            ''
              hello
            ''
          ];

          processes.hello.exec = "hello";
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };

  #Optional: Use the nix / snowblower
  nixConfig = {
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "snowblower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://snowblower.cachix.org"
    ];
  };
}
