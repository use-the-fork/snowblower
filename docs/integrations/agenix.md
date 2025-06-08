# Agenix

Snow Blower provides built-in support for [Agenix](https://github.com/ryantm/agenix), a secrets management tool for Nix that uses age encryption.

## Overview

The Agenix integration allows you to:

- Securely store encrypted environment variables
- Automatically decrypt secrets in your development environment
- Manage secrets with a simple interface
- Keep sensitive data out of your git repository in plain text

## Adding Agenix Support to Your Project

To add Agenix support to your project, you can enable the Agenix module in your `flake.nix` file:

```nix{21-28}
{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    snow-blower.url = "github:use-the-fork/snow-blower";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
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
          # Agenix configuration
          integrations.agenix = {
            enable = true;
            secrets.".env.local" = {
              publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."];
            };
          };
        };
      };
    };
}
```

## Configuration

Agenix secrets are configured in your `flake.nix` file. Each secret is defined with:

- A name (which becomes the output file name)
- A list of public keys that can decrypt the secret
- Optional settings for file path and permissions

Example configuration:

```nix
snow-blower = {
  integrations.agenix = {
    enable = true;
    secrets = {
      ".env.local" = {
        publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."];
        file = "secrets/.env.local.age"; # Optional, defaults to secrets/<name>.age
        mode = "0600"; # Optional, defaults to 0644
      };
    };
  };
};
```

## Usage

### Editing Secrets

Snow Blower provides a convenient command to edit your secrets:

```bash
just agenix
```

This will:

1. Present a menu of available secrets to edit
1. Open the selected secret in your editor
1. Automatically encrypt the file when you save and exit
1. Decrypt the updated secret for immediate use in your environment

### Automatic Decryption

When you enter the development shell, Snow Blower automatically:

1. Creates a `secrets.nix` file with your public keys configuration
1. Attempts to decrypt all configured secrets
1. Makes the decrypted files available in your project directory

If a secret file doesn't exist or can't be decrypted, you'll see a warning message with instructions on how to fix it.

<!--@include: ./agenix-options.md-->
