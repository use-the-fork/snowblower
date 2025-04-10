# Python (languages)

Options for configuring python in the languages category.

## directory
**Location:** perSystem.snow-blower.languages.python.directory

The Python project's root directory. Defaults to the root of the snowblower project.
Can be an absolute path or one relative to the root of the snowblower project.


**Type:**

`string`

**Default:**
```nix
config.snow-blower.paths.root
```

**Example:**

```nix
"./directory"
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## enable
**Location:** perSystem.snow-blower.languages.python.enable

Whether to enable tools for PHP development.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Example:**

```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## libraries
**Location:** perSystem.snow-blower.languages.python.libraries

Additional libraries to make available to the Python interpreter.

This is useful when you want to use Python wheels that depend on native libraries.


**Type:**

`list of absolute path`

**Default:**
```nix
[ "${config.snow-blower.paths.dotfile}/profile" ]

```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## manylinux.enable
**Location:** perSystem.snow-blower.languages.python.manylinux.enable

Whether to install manylinux2014 libraries.

Enabled by default on linux;

This is useful when you want to use Python wheels that depend on manylinux2014 libraries.


**Type:**

`boolean`

**Default:**
```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## package
**Location:** perSystem.snow-blower.languages.python.package

The Python package to use.


**Type:**

`package`

**Default:**
```nix
pkgs.python3
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.activate.enable
**Location:** perSystem.snow-blower.languages.python.poetry.activate.enable

Whether to activate the poetry virtual environment automatically.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.enable
**Location:** perSystem.snow-blower.languages.python.poetry.enable

Whether to enable poetry.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Example:**

```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.allExtras
**Location:** perSystem.snow-blower.languages.python.poetry.install.allExtras

Whether to install all extras. See `--all-extras`.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.compile
**Location:** perSystem.snow-blower.languages.python.poetry.install.compile

Whether `poetry install` should compile Python source files to bytecode.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.enable
**Location:** perSystem.snow-blower.languages.python.poetry.install.enable

Whether to enable poetry install during snowblower initialisation.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Example:**

```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.extras
**Location:** perSystem.snow-blower.languages.python.poetry.install.extras

Which extras to install. See `--extras`.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.groups
**Location:** perSystem.snow-blower.languages.python.poetry.install.groups

Which dependency groups to install. See `--with`.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.ignoredGroups
**Location:** perSystem.snow-blower.languages.python.poetry.install.ignoredGroups

Which dependency groups to ignore. See `--without`.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.installRootPackage
**Location:** perSystem.snow-blower.languages.python.poetry.install.installRootPackage

Whether the root package (your project) should be installed. See `--no-root`

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.onlyGroups
**Location:** perSystem.snow-blower.languages.python.poetry.install.onlyGroups

Which dependency groups to exclusively install. See `--only`.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.onlyInstallRootPackage
**Location:** perSystem.snow-blower.languages.python.poetry.install.onlyInstallRootPackage

Whether to only install the root package (your project) should be installed, but no dependencies. See `--only-root`

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.quiet
**Location:** perSystem.snow-blower.languages.python.poetry.install.quiet

Whether `poetry install` should avoid outputting messages during snowblower initialisation.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.install.verbosity
**Location:** perSystem.snow-blower.languages.python.poetry.install.verbosity

What level of verbosity the output of `poetry install` should have.

**Type:**

`one of "no", "little", "more", "debug"`

**Default:**
```nix
"no"
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## poetry.package
**Location:** perSystem.snow-blower.languages.python.poetry.package

The Poetry package to use.

**Type:**

`package`

**Default:**
```nix
pkgs.poetry
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## uv.enable
**Location:** perSystem.snow-blower.languages.python.uv.enable

Whether to enable uv.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Example:**

```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## uv.package
**Location:** perSystem.snow-blower.languages.python.uv.package

The uv package to use.

**Type:**

`package`

**Default:**
```nix
pkgs.uv
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## venv.enable
**Location:** perSystem.snow-blower.languages.python.venv.enable

Whether to enable Python virtual environment.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Example:**

```nix
true
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## venv.quiet
**Location:** perSystem.snow-blower.languages.python.venv.quiet

Whether `pip install` should avoid outputting messages during snowblower initialisation.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## venv.requirements
**Location:** perSystem.snow-blower.languages.python.venv.requirements

Contents of pip requirements.txt file.
This is passed to `pip install -r` during `snowblower shell` initialisation.


**Type:**

`null or strings concatenated with "\n" or absolute path`

**Default:**
```nix
null
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)


## version
**Location:** perSystem.snow-blower.languages.python.version

The Python version to use.
This automatically sets the `languages.python.package` using [nixpkgs-python](https://github.com/cachix/nixpkgs-python).


**Type:**

`null or string`

**Default:**
```nix
null
```

**Example:**

```nix
"3.11 or 3.11.2"
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](modules/languages/python)

