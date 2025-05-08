# Dotenv

Snow Blower provides built-in support for dotenv files, making it easy to manage environment variables in your development environment.

## Overview

The Dotenv integration allows you to:

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

## Features

### Multiple Dotenv Files

Snow Blower supports loading multiple dotenv files with a defined precedence order:

```nix
snow-blower.dotenv = {
  enable = true;
  files = [
    ".env"
    ".env.local"
    ".env.development"
  ];
};
```

Files listed later in the array take precedence over earlier ones.

### Custom Filename

You can specify a single dotenv file to load:

```nix
snow-blower.dotenv = {
  enable = true;
  filename = ".env.production";
};
```

This is equivalent to setting `files = [".env.production"]`.

### Environment Variable Merging

When multiple dotenv files are specified, Snow Blower merges their contents, with later files overriding variables from earlier files. This allows you to:

- Define common variables in a base `.env` file
- Override specific variables in environment-specific files like `.env.development`
- Keep sensitive credentials in a `.env.local` file that isn't committed to version control

## Usage

Once configured, environment variables from your dotenv files are automatically:

- Loaded when you enter the development shell
- Made available to all processes run within the shell
- Accessible to your application code

No additional commands are needed - the variables are immediately available in your environment.

Example `.env` file:

```
DATABASE_URL=mysql://user:password@localhost:3306/mydb
API_KEY=your_api_key_here
DEBUG=true
```

These variables will be available as `$DATABASE_URL`, `$API_KEY`, and `$DEBUG` in your shell and to any processes you run.
<!--@include: ./dotenv-options.md-->
