# Programming Languages

Snow Blower provides built-in support for various programming languages, making it easy to set up development environments for your projects.

## Supported Languages

Snow Blower currently supports the following programming languages:

- [Java](./java.md) - Java development environment with JDK and build tools
- [JavaScript](./javascript.md) - JavaScript/TypeScript development with Node.js, npm, yarn, pnpm, and Bun
- [PHP](./php.md) - PHP development environment with Composer
- [Python](./python.md) - Python development with virtual environments and package management
- [Ruby](./ruby.md) - Ruby development with Bundler and gem management

Each language module provides:

- Appropriate runtime and compiler installations
- Package managers and build tools
- Development utilities specific to the language
- Integration with other Snow Blower features

## Adding Language Support to Your Project

To add language support to your project, you can enable the specific language module in your `flake.nix` file:

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
          # Language configuration
          languages = {
            python.enable = true;
            javascript = {
              enable = true;
              npm.enable = true;
            };
            # Add other languages as needed
          };
        };
      };
    };
}
```

Refer to the specific language documentation for detailed configuration options.
