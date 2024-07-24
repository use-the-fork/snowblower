# ❄️ 💨 Snow Blower: All flake no fluff.
[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Have you ever wished you could pull down a repo, enter the shell, and have everything set up for you? ME TOO!

That's the purpose of Snow Blower. Setting up a project shouldn't be hard. Getting your team working in the same environment across the board shouldn't be hard either. Snow Blower makes it easy. Just add it to your `flake.nix`, pick the options you want to use, and enter the shell. All the other work is done for you!

## Getting Started

Set up a new project with Nix flakes using our base template:

```sh
nix flake init --template github:use-the-fork/snow-blower
```

This template will create:

* A `flake.nix` file containing a basic development environment configuration.
* A `.envrc` file to optionally set up automatic shell activation.
* A `justfile` to import our dynamically created just files.

Open the `Snow Blower` shell with:

```sh
nix develop --impure
```
or, if you have direnv installed:
```sh
direnv allow
```

This will create a `flake.lock` file and open a new shell based on the configuration specified in `flake.nix`.

Now, go and modify your `flake.nix` file to suit your needs! We have included comments in the flake file to help you get started!

> NOTE: "Why do I need `--impure`?"
>
> When working with flakes, pure mode prevents `Snow Blower` from accessing and modifying its state data as well as accessing any files that may be ignored by git, such as `.env` files.

## Motivation

I wanted to build a pure NixOS environment for developing web-based projects. Devenv is great, but it focuses on too many OSs. I wanted a pure flake implementation.

## Contributing

TODO

## Credit

- Thanks to Devenv for much of the inspiration for this project: https://devenv.sh/
- Thanks to NotAShelf for being a huge inspiration in learning nix: https://github.com/NotAShelf/nyx
