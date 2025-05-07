## Options

### scripts
**Location:** *perSystem.snow-blower.scripts*

A set of scripts available when the environment is active.

**Type:**

`attribute set of (submodule)`

**Default:**
```nix
{ }
```

**Declared by:**

- [scripts, via option flake.flakeModules.scripts](https://github.com/use-the-fork/snow-blower/tree/main/modules/scripts/default.nix)


### description
**Location:** *perSystem.snow-blower.scripts.\<name\>.description*

Description of the script.

**Type:**

`string`

**Default:**
```nix
""
```

**Declared by:**

- [scripts, via option flake.flakeModules.scripts](https://github.com/use-the-fork/snow-blower/tree/main/modules/scripts/default.nix)


### exec
**Location:** *perSystem.snow-blower.scripts.\<name\>.exec*

Shell code to execute when the script is run.

**Type:**

`string`

**Declared by:**

- [scripts, via option flake.flakeModules.scripts](https://github.com/use-the-fork/snow-blower/tree/main/modules/scripts/default.nix)


### enable
**Location:** *perSystem.snow-blower.scripts.\<name\>.just.enable*

Include this script in just runner.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [scripts, via option flake.flakeModules.scripts](https://github.com/use-the-fork/snow-blower/tree/main/modules/scripts/default.nix)


### package
**Location:** *perSystem.snow-blower.scripts.\<name\>.package*

The package to use to run the script.

**Type:**

`package`

**Default:**
```nix
pkgs.bash
```

**Declared by:**

- [scripts, via option flake.flakeModules.scripts](https://github.com/use-the-fork/snow-blower/tree/main/modules/scripts/default.nix)

