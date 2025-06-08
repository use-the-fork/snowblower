# Just

Snow Blower provides built-in support for [Just](https://github.com/casey/just), a handy command runner that serves as a modern alternative to Make.

## Overview

The Just module allows you to:

- Define and run project-specific commands
- Organize commands into recipes
- Share common recipes across your project
- Integrate with other Snow Blower features

## Adding Just Support to Your Project

Just is enabled by default in Snow Blower. You can customize its configuration in your `flake.nix` file:

```nix{21-26}
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
          # Just configuration
          just = {
            package = pkgs.just;
            commonFileName = "just-flake.just";
          };
        };
      };
    };
}
```

## Features

### Recipe Management

Snow Blower allows you to define recipes that are automatically added to a common justfile:

```nix
snow-blower.just.recipes.build = {
  enable = true;
  justfile = ''
    # Build the project
    build:
      cargo build --release
  '';
};
```

These recipes are then available through the `just` command:

```bash
just build
```

### Integration with Other Modules

Many Snow Blower modules automatically add their own recipes to Just. For example:

- The Scripts module can add scripts as Just recipes
- The Agenix module adds commands for managing secrets
- Language modules add language-specific commands

### Common Justfile

Snow Blower generates a common justfile (`just-flake.just` by default) that contains all enabled recipes. This file is automatically imported by the main justfile in your project.

To use it, create a `justfile` in your project root with:

```
import "just-flake.just"

# Your project-specific recipes can go here
```

## Usage

Once configured, you can run Just commands in your development shell:

```bash
# List available recipes
just --list

# Run a specific recipe
just <recipe-name>

# Run multiple recipes
just <recipe1> <recipe2>
```

<!--@include: ./just-options.md-->
