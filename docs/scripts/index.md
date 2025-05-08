# Scripts

Snow Blower provides a flexible system for defining and running custom scripts in your development environment.

## Overview

The Scripts module allows you to:

- Define custom shell scripts that are available in your development environment
- Add these scripts to your `justfile` for easy execution
- Document your scripts with descriptions
- Use different interpreters for different scripts

## Adding Scripts to Your Project

To add scripts to your project, you can define them in your `flake.nix` file:

```nix{21-33}
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
          # Scripts configuration
          scripts = {
            hello = {
              description = "Say hello to the user";
              exec = ''
                echo "Hello, $(whoami)!"
              '';
              just.enable = true;
            };

            backup-db = {
              description = "Backup the database";
              exec = ''
                mkdir -p backups
                date=$(date +%Y-%m-%d)
                mysqldump -u root mydb > "backups/mydb-$date.sql"
                echo "Database backed up to backups/mydb-$date.sql"
              '';
              just.enable = true;
            };
          };
        };
      };
    };
}
```

## Features

### Script Definition

Each script is defined with:

- An `exec` property containing the shell code to execute
- An optional `description` for documentation
- An optional `package` to specify which interpreter to use (defaults to bash)
- Just integration settings

Example:

```nix
snow-blower.scripts.analyze-logs = {
  description = "Analyze application logs for errors";
  exec = ''
    grep -E "ERROR|FATAL" logs/app.log | sort | uniq -c
  '';
  package = pkgs.python3; # Use Python as the interpreter
  just.enable = true;
};
```

### Just Integration

Scripts can be automatically added to your `justfile` by setting `just.enable = true`. This makes them available through the `just` command:

```bash
just hello
```

### Custom Interpreters

By default, scripts use Bash as their interpreter, but you can specify a different one:

```nix
snow-blower.scripts.plot-data = {
  description = "Generate a plot from data";
  exec = ''
    import matplotlib.pyplot as plt
    import numpy as np

    x = np.linspace(0, 10, 100)
    y = np.sin(x)

    plt.plot(x, y)
    plt.savefig('plot.png')
    print("Plot saved to plot.png")
  '';
  package = pkgs.python3;
  just.enable = true;
};
```

## Usage

Once defined, scripts are available in your development shell:

```bash
# Run a script directly
hello

# Or use just if just.enable is true
just hello
```

<!--@include: ./scripts-options.md-->
