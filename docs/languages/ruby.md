# Ruby

Snow Blower provides built-in support for Ruby development, making it easy to set up and manage Ruby environments in your projects.

## Overview

The Ruby language module allows you to:

- Set up Ruby development environments with specific versions
- Manage gems and dependencies with Bundler
- Keep gem installations isolated to your project
- Integrate with other Snow Blower features

## Adding Ruby Support to Your Project

To add Ruby support to your project, you can enable the Ruby module in your `flake.nix` file:

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
          # Ruby configuration
          languages.ruby = {
            enable = true;
            package = pkgs.ruby_3_2;
          };
        };
      };
    };
}
```

## Features

### Ruby Version Selection

You can specify which Ruby version to use by selecting the appropriate package:

```nix
snow-blower.languages.ruby.package = pkgs.ruby_3_2;
```

Available Ruby versions in nixpkgs include:

- `pkgs.ruby` (default, currently Ruby 3.1)
- `pkgs.ruby_3_2` (Ruby 3.2)
- `pkgs.ruby_3_1` (Ruby 3.1)
- `pkgs.ruby_3_0` (Ruby 3.0)

### Bundler Integration

Bundler is enabled by default when you enable Ruby support. You can customize the Bundler package:

```nix
snow-blower.languages.ruby.bundler = {
  enable = true;
  package = pkgs.bundler.override { ruby = pkgs.ruby_3_2; };
};
```

By default, Bundler will use the same Ruby version that you've configured for the Ruby module.

## Environment Variables

When the Ruby module is enabled, Snow Blower automatically sets up the following environment variables:

- `BUNDLE_PATH`: Points to the project-specific bundle directory
- `GEM_HOME`: Points to the gem installation directory

These directories are stored in the project's state directory to keep your home directory clean and ensure that gems are isolated to your project.

## Usage

Once configured, you can use Ruby in your development environment with:

- `ruby` - Run Ruby scripts
- `gem` - Manage Ruby gems
- `bundle` - Manage dependencies with Bundler (when Bundler is enabled)

<!--@include: ./ruby-options.md-->
