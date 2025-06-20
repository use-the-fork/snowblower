{
  description = "A simple flake using the make-shell flake module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snowblower.url = "github:use-the-fork/snowblower";
  };

  outputs = inputs:
    inputs.snowblower.mkSnowBlower {
      inherit inputs;
      perSystem = _: {
        snowblower = {
          paths.src = ./.;

          services = {
            aider = {
              enable = true;
            };
          };

          languages = {
            python = {
              enable = true;
              venv.enable = true;
            };
          };

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
        };
      };
    };

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
