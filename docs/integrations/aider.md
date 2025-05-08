# Aider

Snow Blower provides built-in support for [Aider](https://github.com/paul-gauthier/aider), an AI pair programming tool that helps you code with AI assistants.

## Overview

The Aider integration allows you to:

- Use AI assistants to help with coding tasks
- Edit your codebase through natural language conversations
- Get AI-powered code suggestions and improvements
- Integrate AI assistance into your development workflow

## Adding Aider Support to Your Project

To add Aider support to your project, you can enable the Aider module in your `flake.nix` file:

```nix{21-24}
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
          # Aider configuration
          integrations.aider = {
            enable = true;
          };
        };
      };
    };
}
```

## Configuration

Aider is configured in your `flake.nix` file. The main configuration options include:

- `enable`: Set to `true` to enable Aider
- `package`: The Aider package to use (defaults to the one from nixpkgs)
- `settings`: Configuration settings for Aider behavior

Example configuration:

```nix
snow-blower.integrations.aider = {
  enable = true;
  settings = {
    dark-mode = true;
    auto-lint = true;
    code-theme = "monokai";
  };
};
```

### Commands Configuration

You can define custom Aider commands with specific configurations:

```nix
snow-blower.integrations.aider.commands = {
  default = {
    model = "gpt-4-turbo";
    description = "Start Aider with GPT-4 Turbo";
    gitCommitVerify = true;
    watchFiles = true;
    suggestShellCommands = true;
  };

  lite = {
    model = "gpt-3.5-turbo";
    description = "Start Aider with a faster, lighter model";
    gitCommitVerify = false;
  };
};
```

## Usage

Once configured, you can start Aider in your development shell using the Just commands that are automatically created:

```bash
# Use the default configuration
just ai-default

# Use a specific configuration
just ai-lite
```

<!--@include: ./aider-options.md-->
