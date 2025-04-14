# Dotenv

Snow Blower provides built-in support for dotenv files, making it easy to manage environment variables in your development environment.

## Overview

The dotenv integration allows you to:

- Load environment variables from `.env` files (or custom named files)
- Support multiple dotenv files with precedence order
- Parse and merge environment variables automatically
- Make environment variables immediately available in your development shell

## Adding Dotenv Support to Your Project

To add dotenv support to your project, you can enable the dotenv module in your `flake.nix` file:

```nix{21-25}
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
        inputs.snow-blower.flakeModule
      ];

      src = ./.;

      perSystem = {pkgs, ...}: {
        snow-blower = {
          # Dotenv configuration
          dotenv = {
            enable = true;
            filename = ".env.local"; # Optional, defaults to ".env"
          };
        };
      };
    };
}
```
<!--@include: ./dotenv-options.md-->
