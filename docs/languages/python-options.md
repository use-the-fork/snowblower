## Options

### enable

**Location:** *perSystem.snow-blower.languages.python.enable*

Whether to enable tools for Python development.

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

- [languages/python, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/python/default.nix)

### uv.package

**Location:** *perSystem.snow-blower.languages.python.uv.package*

The uv package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.uv
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/python/default.nix)

### venv.enable

**Location:** *perSystem.snow-blower.languages.python.venv.enable*

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

- [languages/python, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/python/default.nix)

### version

**Location:** *perSystem.snow-blower.languages.python.version*

The Python version to use.
This is used by UV to download the proper python version.

**Type:**

`null or string`

**Default:**

```nix
"3.11"
```

**Example:**

```nix
"3.11 or 3.11.2"
```

**Declared by:**

- [languages/python, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/python/default.nix)
