---
layout: home
hero:
  name: "Snow Blower"
  text: "All flake no fluff."
  tagline: A Nix-based development environment manager
  image:
    src: /logo.png
    alt: Snow Blower
  actions:
    - theme: brand
      text: Get Started
      link: /integrations
    - theme: alt
      text: View on GitHub
      link: https://github.com/use-the-fork/snow-blower
features:
  - title: Easy Setup
    details: Pull down a repo, enter the shell, and have everything set up for you automatically.
  - title: Team Consistency
    details: Ensure your entire team works in the same environment across different machines.
  - title: Nix Powered
    details: Built with Nix flakes for reproducible and declarative development environments.
---

# ❄️ 💨 Snow Blower

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

::: warning NOTE
When working with flakes, pure mode prevents `Snow Blower` from accessing and modifying its state data as well as accessing any files that may be ignored by git, such as `.env` files. That's why you need to use `--impure`.
:::

## Motivation

I wanted to build a pure NixOS environment for developing web-based projects. Devenv is great, but it focuses on too many OSs. I wanted a pure flake implementation.
