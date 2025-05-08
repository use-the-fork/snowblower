# Python

Snow Blower provides built-in support for Python development, making it easy to set up and manage Python environments in your projects.

## Overview

The Python language module allows you to:

- Set up Python development environments with specific versions
- Manage virtual environments for isolated dependencies
- Use modern Python tooling like `uv` for faster package management
- Integrate with other Snow Blower features

## Adding Python Support to Your Project

To add Python support to your project, you can enable the Python module in your `flake.nix` file:

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
          # Python configuration
          languages.python = {
            enable = true;
            version = "3.11";
            venv.enable = true;
          };
        };
      };
    };
}
```

## Features

### Python Version Selection

You can specify which Python version to use:

```nix
snow-blower.languages.python.version = "3.11";
```

This setting is used by the `uv` tool to download the appropriate Python version.

### Virtual Environments

Snow Blower can automatically set up and manage a Python virtual environment for your project:

```nix
snow-blower.languages.python.venv.enable = true;
```

When enabled, a virtual environment will be created in your project directory, and the development shell will be configured to activate it automatically.

### UV Package Manager

Snow Blower uses [uv](https://github.com/astral-sh/uv), a modern Python package manager and resolver that's significantly faster than pip. UV is included by default when you enable Python support.

You can customize the UV package:

```nix
snow-blower.languages.python.uv.package = pkgs.uv;
```

## Usage

Once configured, you can use Python in your development environment with:

- `python` - Run Python scripts
- `uv` - Manage packages with the UV package manager
- Standard Python tools like `pytest`, `black`, etc. (when installed in your virtual environment)

### Installing Dependencies

With UV enabled, you can install dependencies using:

```bash
uv add requests pandas
```

For development dependencies:

```bash
uv add --dev pytest black mypy
```

You can also install from a requirements file:

```bash
uv add -r requirements.txt
```

Or install your project in development mode:

```bash
uv add -e .
```

UV is significantly faster than traditional pip, especially for large dependency trees.

<!--@include: ./python-options.md-->
