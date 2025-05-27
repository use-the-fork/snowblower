# ❄️ 💨 SnowBlower: All flake no fluff.
[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Have you ever wished you could pull down a repo, enter the shell, and have everything set up for you? SnowBlower makes that possible!

SnowBlower is an opinionated development environment. It provides a consistent, reproducible environment for your entire team with minimal configuration.

Setting up a project shouldn't be hard. Getting your team working in the same environment across different machines shouldn't be hard either.

## Principles
SnowBlower believes:

* Configurations should come from one centralized source of truth.
* Configurations should be easy to understand and be standardized.
* Configurations should all be written in one language.
* Containers should be easy to set up and execute regardless of what environment you are on.
* Developers should be able to have a pleasant, easy-to-setup environment regardless of what IDE they use.
* Environments should be easy to maintain and upgrade. That includes tooling, languages, and services.


## SnowBlower to the rescue.
To solve for this we have SnowBlower. SnowBlower uses one centralized `snowblower.yml` configuration.
This file allows us to set up the entire environment as we see fit and then SnowBlower takes care of the rest. 

This happens through the use of `Devcontainers`, `Nix`, `Flakes`, and `Home Manager`.

### Devcontainers
Devcontainers are widely supported and built into popular editors like VSCode and JetBrains. Since there is no use in 'reinventing' the wheel, we leverage Devcontainers and Docker.

To do this we have created a custom image `docker.io/usethefork/snow-blower` the foundation of which is `debian:stable-slim` but uses Nix.

### `Nix`, `Flakes` and `Home Manager` Oh My!
The reason we use `debian:stable-slim` as our foundation instead of `NixOS` is to avoid some of the minor pitfalls of NixOS. Things that Nix-LD (https://github.com/nix-community/nix-ld) aims to solve.

But by using `debian:stable-slim` as the base and then adding `Nix` as the package manager allows us to have the best of both worlds. We can declaratively create our own environment but not have problems when packages like `NPM` try to install things globally.

The real secret sauce however is `Home Manager` (https://github.com/nix-community/home-manager). `Home Manager` provides a basic system for managing a user environment using the Nix package manager together with the Nix libraries found in Nixpkgs. It allows declarative configuration of user specific (non-global) packages and dotfiles.

This ends up being perfect in our use case as it creates one unified dev environment that is identical across all developers. Neat right!

## Example
Let's say we are working on a Laravel (PHP framework) project. We know we need:
  * PHP (8.3)
  * Composer
  * JavaScript (Node 22)
  * Yarn (Berry)
  * Pint (PHP Linting)
  * Prettier (JavaScript Linting)
  * MySQL (The Database)

Normally this would require:

```ini php.ini
[PHP]
engine = On
short_open_tag = Off
error_reporting = E_ALL | E_STRICT
```

```json pint.json
{
  "preset": "laravel",
  "rules": {
    "simplified_null_return": true
  }
}
```

```json .prettierrc.json
{
  "trailingComma": "es5",
  "tabWidth": 4,
  "semi": false,
  "singleQuote": true
}
```

And this doesn't even include installing all of these dependencies, getting the right version of PHP, Node, etc. And that's just for you! What about the rest of your team?

With SnowBlower, this can all be done in one clean file.
```yml snowblower.yml
languages:
  php:
    enabled: true
    package: "php83"
    settings:
      php:
        engine: "on"
        error_reporting: "E_ALL"
        memory_limit: "512M"
    tools:
      composer:
        enabled: true
        package: "php83Packages.composer"
      pint:
        enabled: true
        settings:
          preset: "laravel"
          rules:
            simplified_null_return: true

  javascript:
    enabled: true
    package: "nodejs_22"
    tools:
      yarn:
        enabled: true
        package: "yarn-berry"
      prettier:
        enabled: true
        package: "prettierd"
        settings:
          trailingComma: "es5"
          tabWidth: 4
          semi: false
          singleQuote: true
services:
  mysql:
    image: "mysql/mysql-server:8.0"
    ports:
      - "${FORWARD_DB_PORT:-3306}:3306"
    environment:
      MYSQL_ROOT_PASSWORD: "${DB_PASSWORD}"
      MYSQL_ROOT_HOST: "%"
      MYSQL_DATABASE: "${DB_DATABASE}"
      MYSQL_USER: "${DB_USERNAME}"
      MYSQL_PASSWORD: "${DB_PASSWORD}"
      MYSQL_ALLOW_EMPTY_PASSWORD: 1
    volumes:
      - "sailmysql:/var/lib/mysql"
    networks:
      - sail
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-p${DB_PASSWORD}"]
      retries: 3
      timeout: 5s

```

The above sets up everything in one unified file. including what packages and settings to use. Everything else is done for you!


## Contributing

Contributions are welcome! Please see our [contributing guidelines](https://github.com/use-the-fork/snow-blower/blob/main/CONTRIBUTING.md) for more information.

## Credits

- Thanks to [Devenv](https://devenv.sh/) for much of the inspiration for this project
- Thanks to [NotAShelf](https://github.com/NotAShelf/nyx) for being a huge inspiration in learning Nix
