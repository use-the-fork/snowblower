# Git Cliff

Snow Blower provides built-in support for [git-cliff](https://github.com/orhun/git-cliff), a highly customizable changelog generator that follows Conventional Commits.

## Overview

The git-cliff integration allows you to:

- Generate changelogs from your git history
- Customize the changelog format and style
- Automatically follow Conventional Commits specification
- Integrate with your CI/CD pipeline

## Adding Git Cliff Support to Your Project

To add git-cliff support to your project, you can enable the git-cliff module in your `flake.nix` file:

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
          # Git Cliff configuration
          git-cliff.enable = true;
        };
      };
    };
}
```

## Configuration

Snow Blower provides a default configuration for Git Cliff that follows conventional commits. The integration:

- Automatically creates a well-structured changelog
- Groups commits by type (features, bug fixes, etc.)
- Formats the output in a standardized way
- Supports GitHub repository integration

You can customize the configuration by modifying the settings in your `flake.nix`:

```nix
snow-blower = {
  git-cliff = {
    enable = true;
    settings = {
      file-name = "CHANGELOG.md"; # Default output filename
      integrations.github.enable = true; # Enable GitHub integration
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
- Group commits by type according to conventional commits
- Generate a formatted changelog
- Save it to the configured file (default: CHANGELOG.md)

If GitHub integration is enabled, the changelog will also include links to your GitHub repository.

<!--@include: ./git-cliff-options.md-->
