# PHP

Snow Blower provides built-in support for PHP development, making it easy to set up and manage PHP environments in your projects.

## Overview

The PHP language module allows you to:

- Set up PHP development environments with specific versions
- Configure PHP extensions and settings
- Integrate with other Snow Blower services like MySQL and Blackfire
- Manage Composer dependencies

## Adding PHP Support to Your Project

To add PHP support to your project, you can enable the PHP module in your `flake.nix` file:

```nix{21-26}
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
          # PHP configuration
          languages.php = {
            enable = true;
            extensions = ["xdebug" "redis" "imagick"];
          };
        };
      };
    };
}
```

## Features

### PHP Version Selection

You can specify which PHP version to use by selecting the appropriate package:

```nix
snow-blower.languages.php.package = pkgs.php83;
```

Available PHP versions in nixpkgs include:

- `pkgs.php` (default, currently PHP 8.2)
- `pkgs.php83` (PHP 8.3)
- `pkgs.php81` (PHP 8.1)

You can find the latest available PHP versions at [search.nixos.org](https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=php).

### PHP Extensions

You can enable PHP extensions by adding them to the `extensions` list:

```nix
snow-blower.languages.php.extensions = [
  "xdebug"
  "redis"
  "imagick"
  "intl"
];
```

If you need to disable certain extensions that are enabled by default:

```nix
snow-blower.languages.php.disableExtensions = [
  "opcache"
];
```

### PHP Configuration

You can customize PHP settings by adding directives to the `ini` option:

```nix
snow-blower.languages.php.ini = ''
  memory_limit = 512M
  display_errors = On
  error_reporting = E_ALL
  date.timezone = "UTC"
'';
```

### Composer Integration

Composer is included by default when you enable PHP support. You can customize the Composer package:

```nix
snow-blower.languages.php.packages.composer = pkgs.phpPackages.composer;
```

## Integration with Services

The PHP module automatically integrates with other Snow Blower services:

- When MySQL is enabled, PHP is configured to use the correct socket
- When Blackfire is enabled, PHP is configured to connect to the Blackfire agent

## Usage

Once configured, you can use PHP in your development environment with:

- `php` - Run PHP scripts
- `composer` - Manage PHP dependencies
- PHP extensions enabled as configured

### Installing Dependencies

With Composer enabled, you can install dependencies using:

```bash
composer install
```

<!--@include: ./php-options.md-->
