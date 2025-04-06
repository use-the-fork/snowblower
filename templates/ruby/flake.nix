{
  description = "A simple flake using the make-shell flake module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snow-blower.url = "github:use-the-fork/snow-blower";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      inherit inputs;
      perSystem = {
        config,
        pkgs,
        ...
      }: let
        serv = config.snow-blower.services;
        lang = config.snow-blower.languages;
        env = config.snow-blower.env;
      in {
        snow-blower = {
          paths.src = ./.;

          services = {
            aider = {
              enable = true;
            };
          };

          languages = {
            ruby = {
              enable = true;
            };
          };

          integrations = {
            #the options here mirror the offical repo: https://github.com/numtide/treefmt-nix/tree/main
            treefmt = {
              programs = {
                #formater for nix
                alejandra.enable = true;
                rubocop.enable = true;
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
        "snow-blower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
      ];

      extra-substituters = [
        "https://cache.nixos.org"
        "https://snow-blower.cachix.org"
      ];
    };

}
