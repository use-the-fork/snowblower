## perSystem

A function from system to flake-like attributes omitting the `<system>`
attribute.

Modules defined here have access to the suboptions and [some convenient
module arguments](../module-arguments.html).

*Type:* module

*Declared by:*

- [languages/ruby, via option
  flake.flakeModules.languages](modules/languages/ruby)
- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)
- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)
- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)
- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.enable

Whether to enable tools for Java development.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.package

The package Java should use.

*Type:* package

*Default:* `<derivation openjdk-21.0.5+11>`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.settings.gradle.enable

Whether to enable gradle.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.settings.gradle.package

The Gradle package to use. The Gradle package by default inherits the
JDK from `languages.java.package`.

*Type:* package

*Default:* `pkgs.gradle.override { java = cfg.package; }`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.settings.maven.enable

Whether to enable maven.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.java.settings.maven.package

The Maven package to use. The Maven package by default inherits the JDK
from `languages.java.package`.

*Type:* package

*Default:* `"pkgs.maven.override { jdk = cfg.package; }"`

*Declared by:*

- [languages/java, via option
  flake.flakeModules.languages](modules/languages/java)

## perSystem.snow-blower.languages.javascript.enable

Whether to enable tools for JavaScript development.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.package

The Node.js package to use.

*Type:* package

*Default:* `pkgs.nodejs-slim`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.bun.enable

Whether to enable install bun.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.bun.package

The bun package to use.

*Type:* package

*Default:* `pkgs.bun`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.bun.install.enable

Whether to enable bun install during snow blower initialisation.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.corepack.enable

Whether to enable wrappers for npm, pnpm and Yarn via Node.js Corepack.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.directory

The JavaScript project’s root directory. Defaults to the root of the
devenv project. Can be an absolute path or one relative to the root of
the snow blower project.

*Type:* string

*Default:* `config.snow-blower.paths.root`

*Example:* `"./directory"`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.npm.enable

Whether to enable install npm.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.npm.package

The Node.js package to use.

*Type:* package

*Default:* `pkgs.nodejs`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.npm.install.enable

Whether to enable npm install during snow blower initialisation.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.pnpm.enable

Whether to enable install pnpm.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.pnpm.package

The pnpm package to use.

*Type:* package

*Default:* `pkgs.nodePackages.pnpm`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.pnpm.install.enable

Whether to enable pnpm install during snow blower initialisation.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.yarn.enable

Whether to enable install yarn.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.yarn.package

The yarn package to use.

*Type:* package

*Default:* `pkgs.yarn`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.javascript.yarn.install.enable

Whether to enable yarn install during snow blower initialisation.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/javascript, via option
  flake.flakeModules.languages](modules/languages/javascript)

## perSystem.snow-blower.languages.php.enable

Whether to enable tools for PHP development.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.package

Allows you to [override the default used
package](https://nixos.org/manual/nixpkgs/stable/#ssec-php-user-guide)
to adjust the settings or add more extensions. You can find the
extensions using `devenv search 'php extensions'`

*Type:* package

*Default:* `pkgs.php`

*Example:*

    pkgs.php.buildEnv {
      extensions = { all, enabled }: with all; enabled ++ [ xdebug ];
      extraConfig = ''
        memory_limit=1G
      '';
    };

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.packages

Attribute set of packages including composer

*Type:* submodule

*Default:* `pkgs`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.packages.composer

composer package

*Type:* null or package

*Default:* `pkgs.phpPackages.composer`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.disableExtensions

PHP extensions to disable.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.extensions

PHP extensions to enable.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.php.ini

PHP.ini directives. Refer to the “List of php.ini directives” of PHP’s

*Type:* null or strings concatenated with “\n”

*Default:* `""`

*Declared by:*

- [languages/php, via option
  flake.flakeModules.languages](modules/languages/php)

## perSystem.snow-blower.languages.python.enable

Whether to enable tools for PHP development.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.package

The Python package to use.

*Type:* package

*Default:* `pkgs.python3`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.directory

The Python project’s root directory. Defaults to the root of the
snowblower project. Can be an absolute path or one relative to the root
of the snowblower project.

*Type:* string

*Default:* `config.snow-blower.paths.root`

*Example:* `"./directory"`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.libraries

Additional libraries to make available to the Python interpreter.

This is useful when you want to use Python wheels that depend on native
libraries.

*Type:* list of absolute path

*Default:*

    [ "${config.snow-blower.paths.dotfile}/profile" ]

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.manylinux.enable

Whether to install manylinux2014 libraries.

Enabled by default on linux;

This is useful when you want to use Python wheels that depend on
manylinux2014 libraries.

*Type:* boolean

*Default:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.enable

Whether to enable poetry.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.package

The Poetry package to use.

*Type:* package

*Default:* `pkgs.poetry`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.activate.enable

Whether to activate the poetry virtual environment automatically.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.enable

Whether to enable poetry install during snowblower initialisation.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.allExtras

Whether to install all extras. See `--all-extras`.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.compile

Whether `poetry install` should compile Python source files to bytecode.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.extras

Which extras to install. See `--extras`.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.groups

Which dependency groups to install. See `--with`.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.ignoredGroups

Which dependency groups to ignore. See `--without`.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.installRootPackage

Whether the root package (your project) should be installed. See
`--no-root`

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.onlyGroups

Which dependency groups to exclusively install. See `--only`.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.onlyInstallRootPackage

Whether to only install the root package (your project) should be
installed, but no dependencies. See `--only-root`

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.quiet

Whether `poetry install` should avoid outputting messages during
snowblower initialisation.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.poetry.install.verbosity

What level of verbosity the output of `poetry install` should have.

*Type:* one of “no”, “little”, “more”, “debug”

*Default:* `"no"`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.uv.enable

Whether to enable uv.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.uv.package

The uv package to use.

*Type:* package

*Default:* `pkgs.uv`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.venv.enable

Whether to enable Python virtual environment.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.venv.quiet

Whether `pip install` should avoid outputting messages during snowblower
initialisation.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.venv.requirements

Contents of pip requirements.txt file. This is passed to
`pip install -r` during `snowblower shell` initialisation.

*Type:* null or strings concatenated with “\n” or absolute path

*Default:* `null`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.python.version

The Python version to use. This automatically sets the
`languages.python.package` using
[nixpkgs-python](https://github.com/cachix/nixpkgs-python).

*Type:* null or string

*Default:* `null`

*Example:* `"3.11 or 3.11.2"`

*Declared by:*

- [languages/python, via option
  flake.flakeModules.languages](modules/languages/python)

## perSystem.snow-blower.languages.ruby.enable

Whether to enable tools for Ruby development.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/ruby, via option
  flake.flakeModules.languages](modules/languages/ruby)

## perSystem.snow-blower.languages.ruby.package

The Ruby package to use.

*Type:* package

*Default:* `pkgs.ruby`

*Declared by:*

- [languages/ruby, via option
  flake.flakeModules.languages](modules/languages/ruby)

## perSystem.snow-blower.languages.ruby.bundler.enable

Whether to enable bundler.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [languages/ruby, via option
  flake.flakeModules.languages](modules/languages/ruby)

## perSystem.snow-blower.languages.ruby.bundler.package

The bundler package to use.

*Type:* package

*Default:* `pkgs.bundler.override { ruby = cfg.package; }`

*Declared by:*

- [languages/ruby, via option
  flake.flakeModules.languages](modules/languages/ruby)
