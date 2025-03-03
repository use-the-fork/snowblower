{
  description = "A simple flake using the make-shell flake module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snow-blower.url = "github:use-the-fork/snow-blower";
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";

    accept-flake-config = true;
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://cache.garnix.io"
      "https://devenv.cachix.org"
    ];
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
}
