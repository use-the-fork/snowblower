# Java

Snow Blower provides built-in support for Java development, making it easy to set up and manage Java environments in your projects.

## Overview

The Java language module allows you to:

- Set up Java development environments with specific JDK versions
- Configure build tools like Maven and Gradle
- Manage Java dependencies and build processes
- Integrate with other Snow Blower features

## Adding Java Support to Your Project

To add Java support to your project, you can enable the Java module in your `flake.nix` file:

```nix{21-27}
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
          # Java configuration
          languages.java = {
            enable = true;
            package = pkgs.jdk17;
            settings.maven.enable = true;
          };
        };
      };
    };
}
```

## Features

### JDK Version Selection

You can specify which JDK version to use by selecting the appropriate package:

```nix
snow-blower.languages.java.package = pkgs.jdk17;
```

Available JDK versions in nixpkgs include:
- `pkgs.jdk` (default, currently JDK 21)
- `pkgs.jdk21` (JDK 21)
- `pkgs.jdk17` (JDK 17 LTS)
- `pkgs.jdk11` (JDK 11 LTS)
- `pkgs.jdk8` (JDK 8 LTS)

### Build Tools

#### Maven

You can enable Maven support with:

```nix
snow-blower.languages.java.settings.maven = {
  enable = true;
  package = pkgs.maven.override { jdk_headless = cfg.package; };
};
```

By default, Maven will use the same JDK that you've configured for the Java module.

#### Gradle

You can enable Gradle support with:

```nix
snow-blower.languages.java.settings.gradle = {
  enable = true;
  package = pkgs.gradle.override { java = cfg.package; };
};
```

Like Maven, Gradle will use the same JDK that you've configured for the Java module by default.

## Environment Variables

When the Java module is enabled, Snow Blower automatically sets up the following environment variables:

- `JAVA_HOME`: Points to the selected JDK
- `M2_HOME`: Points to the Maven cache directory (when Maven is enabled)
- `GRADLE_USER_HOME`: Points to the Gradle cache directory (when Gradle is enabled)

These directories are stored in the project's state directory to keep your home directory clean.

## Usage

Once configured, you can use Java in your development environment with:

- `java` - Run Java applications
- `javac` - Compile Java source code
- `mvn` - Run Maven commands (when Maven is enabled)
- `gradle` - Run Gradle commands (when Gradle is enabled)


<!--@include: ./java-options.md-->
