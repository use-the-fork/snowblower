# Convco

Snow Blower provides built-in support for [Convco](https://github.com/convco/convco), a tool for working with Conventional Commits.

## Overview

The Convco integration allows you to:

- Generate changelogs from your git history
- Validate commit messages against Conventional Commits specification
- Automatically determine the next semantic version
- Simplify release management

## Adding Convco Support to Your Project

To add Convco support to your project, you can enable the Convco module in your `flake.nix` file:

```nix{21-23}
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
          # Convco configuration
          integrations.convco.enable = true;
        };
      };
    };
}
```

## Configuration

You can customize the Convco configuration by modifying the settings in your `flake.nix`:

```nix
snow-blower = {
  integrations.convco = {
    enable = true;
    settings = {
      file-name = "CHANGELOG.md"; # Default output filename
    };
  };
};
```

## Usage

Once enabled, you can generate a changelog using the `just` command:

```bash
just changelog
```

This will:
- Analyze your git history
- Generate a formatted changelog based on conventional commits
- Save it to the configured file (default: CHANGELOG.md)

<!--@include: ./convco-options.md-->
