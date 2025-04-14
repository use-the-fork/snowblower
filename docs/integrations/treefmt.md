# Treefmt

Snow Blower provides built-in support for [treefmt-nix](https://github.com/numtide/treefmt-nix), a powerful code formatter that can format your entire source tree with a single command.

## Overview

The Treefmt integration allows you to:

- Format your entire codebase with a single command
- Support multiple languages and formatting tools
- Integrate with Git hooks for automatic formatting
- Customize formatting rules per project

## Adding Treefmt Support to Your Project

To add Treefmt support to your project, you can enable the Treefmt module in your `flake.nix` file:

```nix{21-28}
{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    snow-blower.url = "github:use-the-fork/snow-blower";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
          # Treefmt configuration
          integrations.treefmt = {
            projectRoot = ./.;
            programs = {
              nixpkgs-fmt.enable = true;
              prettier.enable = true;
            };
          };
        };
      };
    };
}
```

## Available Formatters

Since Snow Blower directly integrates with treefmt-nix, all formatters available in that project are also available here. Some common formatters include:

- `nixpkgs-fmt` - For Nix files
- `prettier` - For JavaScript, TypeScript, CSS, HTML, etc.
- `black` - For Python
- `rustfmt` - For Rust
- `shfmt` - For shell scripts

You can enable these formatters using the same syntax:

```nix
snow-blower.integrations.treefmt.programs.nixpkgs-fmt.enable = true;
```

## Configuration

Treefmt is configured through the `programs` attribute in your `flake.nix`. Each formatter can have its own configuration:

```nix
snow-blower.integrations.treefmt = {
  projectRoot = ./.;
  programs = {
    nixpkgs-fmt.enable = true;
    prettier = {
      enable = true;
      includes = ["*.js" "*.ts" "*.jsx" "*.tsx" "*.json" "*.md"];
    };
    black = {
      enable = true;
      includes = ["*.py"];
    };
  };
};
```

## Usage

Once enabled, you can format your entire codebase using the `just` command:

```bash
just fmt
```

This will run all configured formatters on your codebase, ensuring consistent code style across your project.

### Git Integration

Treefmt automatically integrates with Git hooks if you have the Git Hooks integration enabled:

```nix
snow-blower.integrations.git-hooks.hooks.treefmt.enable = true;
```

This will run Treefmt before each commit, ensuring that all committed code is properly formatted.

<!--@include: ./treefmt-options.md-->
