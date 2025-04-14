# Git Hooks

Snow Blower provides built-in support for [git-hooks.nix](https://github.com/cachix/git-hooks.nix), making it easy to set up and manage Git hooks in your development environment.

## Overview

The Git Hooks integration allows you to:

- Automatically set up pre-commit, commit-msg, and other Git hooks
- Enforce code quality standards before commits
- Validate commit messages against conventions
- Integrate with various linting and formatting tools

## Adding Git Hooks Support to Your Project

To add Git Hooks support to your project, you can enable the Git Hooks module in your `flake.nix` file:

```nix{21-27}
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
          # Git Hooks configuration
          integrations.git-hooks = {
            hooks = {
              commitlint.enable = true;
              # Add other hooks as needed
            };
          };
        };
      };
    };
}
```

## Available Hooks

Snow Blower provides several pre-configured hooks:

### Commitlint

The `commitlint` hook validates commit messages against the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```nix
snow-blower.integrations.git-hooks.hooks.commitlint.enable = true;
```

This ensures that all commit messages follow a consistent format, making it easier to generate changelogs and understand the purpose of each commit.

### Standard git-hooks.nix Hooks

Since Snow Blower directly integrates with git-hooks.nix, all hooks available in that project are also available here. Some examples include:

- `pre-commit-hooks.nixpkgs-fmt`
- `pre-commit-hooks.shellcheck`
- `pre-commit-hooks.markdownlint`
- `pre-commit-hooks.prettier`

You can enable these hooks using the same syntax:

```nix
snow-blower.integrations.git-hooks.hooks.nixpkgs-fmt.enable = true;
```

### Custom Hooks

You can also define custom hooks by using the full git-hooks.nix configuration:

```nix
snow-blower.integrations.git-hooks.hooks.<name> = {
  enable = true;
  entry = "${pkgs.my-tool}/bin/my-tool";
  stages = ["pre-commit"];
  description = "Run my custom tool";
};
```

## Configuration

Git Hooks are automatically installed when you enter the development shell. The hooks are configured to:

- Exclude certain files (like LICENSE, flake.lock, SVGs, etc.)
- Fail fast (stop running hooks if one fails)
- Provide verbose output for better debugging

## Usage

Once configured, Git Hooks will automatically run when you perform Git operations. For example:

- When you run `git commit`, the pre-commit hooks will check your code
- When you write a commit message, the commit-msg hooks will validate it

No additional commands are needed - the hooks integrate seamlessly with your normal Git workflow.

<!--@include: ./git-hooks-options.md-->
