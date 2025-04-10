# Integrations

Snow Blower provides built-in support for various integrations, making it easy to enhance your development environment with powerful tools and workflows.

## Supported Integrations

Snow Blower currently supports the following integrations:

- [Agenix](./agenix.md) - Secret management with age encryption
- [Convco](./convco.md) - Conventional commits tooling
- [Dotenv](../dotenv/index.md) - Environment variable management
- [Git Cliff](./git-cliff.md) - Changelog generator from git history
- [Git Hooks](./git-hooks.md) - Automated git hooks
- [Treefmt](./treefmt.md) - Multi-language formatter

Each integration module provides:

- Automatic installation and configuration
- Development-ready defaults
- Integration with other Snow Blower features
- Easy customization options

## Adding Integrations to Your Project

To add integrations to your project, you can enable the specific integration module in your `flake.nix` file:

```nix
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
          # Integrations configuration
          integrations = {
            treefmt = {
              enable = true;
              programs = {
                alejandra.enable = true;  # Nix formatter
                prettier.enable = true;   # JavaScript/TypeScript formatter
              };
            };
            git-hooks.hooks = {
              treefmt.enable = true;      # Format code on commit
            };
            # Add other integrations as needed
          };
        };
      };
    };
}
```

Refer to the specific integration documentation for detailed configuration options.
