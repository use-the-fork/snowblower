# Processes

Snow Blower provides a powerful system for defining and managing background processes in your development environment.

## Overview

The Processes module allows you to:

- Define and run multiple background processes simultaneously
- Manage process dependencies and startup order
- Monitor process status through a terminal UI
- Restart processes automatically when they fail
- Control all processes with simple commands

## Adding Processes to Your Project

To add processes to your project, you can define them in your `flake.nix` file:

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
          # Processes configuration
          processes = {
            web-server = {
              exec = ''
                cd frontend && npm run dev
              '';
            };
            
            api-server = {
              exec = ''
                cd backend && php artisan serve --port=8000
              '';
              process-compose = {
                depends_on = {
                  "web-server" = {
                    condition = "process_started";
                  };
                };
              };
            };
          };
        };
      };
    };
}
```

## Features

### Process Definition

Each process is defined with:

- An `exec` property containing the shell code to execute
- Optional `process-compose` settings for advanced configuration

Example:

```nix
snow-blower.processes.database = {
  exec = ''
    mysqld --datadir=$MYSQL_HOME
  '';
  process-compose = {
    availability = {
      restart = "on_failure";
      backoff_seconds = 2;
      max_restarts = 5;
    };
  };
};
```

### Process Dependencies

You can define dependencies between processes to ensure they start in the correct order:

```nix
snow-blower.processes.api = {
  exec = ''
    node api-server.js
  '';
  process-compose = {
    depends_on = {
      "database" = {
        condition = "process_healthy";
      };
    };
  };
};
```

Available conditions include:

- `process_started`: Wait until the dependency has started
- `process_completed`: Wait until the dependency has completed
- `process_completed_successfully`: Wait until the dependency has completed successfully
- `process_healthy`: Wait until the dependency is healthy (requires a health check)

### Process Environment Variables

Each process inherits all environment variables defined in your Snow Blower configuration. You can also add process-specific environment variables:

```nix
snow-blower.processes.worker = {
  exec = ''
    node worker.js
  '';
  process-compose = {
    environment = [
      "WORKER_THREADS=4"
      "WORKER_QUEUE=high-priority"
    ];
  };
};
```

## Usage

Once configured, you can start all processes with:

```bash
just up
```

This will:

1. Start all defined processes in the correct order
1. Open a terminal UI showing the status of each process
1. Display the logs from all processes in a unified view

You can navigate the UI with:

- Arrow keys to select different processes
- Enter to focus on a specific process's logs
- Ctrl+C to stop all processes and exit

<!--@include: ./processes-options.md-->
