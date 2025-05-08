# ❄️ 💨 Snow Blower: All flake no fluff.
[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Have you ever wished you could pull down a repo, enter the shell, and have everything set up for you? Snow Blower makes that possible!

Snow Blower is an opinionated development environment primarily for web-based tools and frameworks. It provides a consistent, reproducible environment for your entire team with minimal configuration.

Setting up a project shouldn't be hard. Getting your team working in the same environment across different machines shouldn't be hard either. Snow Blower makes it easy - just add it to your `flake.nix`, pick the options you want to use, and enter the shell. All the other work is done for you!

## Getting Started

Set up a new project with Nix flakes using our base template:

```sh
nix flake init --template github:use-the-fork/snow-blower
```

This template will create:

* A `flake.nix` file containing a basic development environment configuration
* A `.envrc` file to optionally set up automatic shell activation
* A `justfile` to import our dynamically created just files

Open the Snow Blower shell with:

```sh
nix develop --impure
```

Or, if you have direnv installed:

```sh
direnv allow
```

This will create a `flake.lock` file and open a new shell based on the configuration specified in `flake.nix`.

Now, modify your `flake.nix` file to suit your needs! We've included comments in the flake file to help you get started.

> **NOTE**: Why do I need `--impure`?
>
> When working with flakes, pure mode prevents Snow Blower from accessing and modifying its state data as well as accessing any files that may be ignored by git, such as `.env` files.

## Features

Snow Blower provides a comprehensive development environment with:

- **Language Support**: Python, JavaScript/TypeScript, PHP, Ruby, Java, and more
- **Service Integration**: MySQL, Redis, Elasticsearch, Memcached, and others
- **Development Tools**: Git hooks, formatting tools, linters, and more
- **Process Management**: Run and monitor multiple processes with dependencies
- **Environment Variables**: Manage with dotenv files and secrets with Agenix
- **Task Running**: Just-based task runner for common development tasks

All features are modular - enable only what you need for your project.

## Documentation

Visit our [documentation site](https://use-the-fork.github.io/snow-blower/) for detailed information on all available modules and configuration options.

## Motivation

Snow Blower was created to build a pure NixOS environment for developing web-based projects. While Devenv is great, it focuses on too many operating systems. Snow Blower provides a pure flake implementation focused on developer productivity.

## Contributing

Contributions are welcome! Please see our [contributing guidelines](https://github.com/use-the-fork/snow-blower/blob/main/CONTRIBUTING.md) for more information.

## Credits

- Thanks to [Devenv](https://devenv.sh/) for much of the inspiration for this project
- Thanks to [NotAShelf](https://github.com/NotAShelf/nyx) for being a huge inspiration in learning Nix
