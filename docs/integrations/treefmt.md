# Treefmt (integrations)

Options for configuring treefmt in the integrations category.

## 
**Location:** perSystem.snow-blower.integrations.treefmt

Integration of https://github.com/numtide/treefmt-nix

**Type:**

`submodule`

**Default:**
```nix
{ }
```

**Declared by:**

- [integrations/treefmt, via option flake.flakeModules.integrations](modules/integrations/treefmt)


## just.enable
**Location:** perSystem.snow-blower.integrations.treefmt.just.enable

Whether to enable enable just command.

**Type:**

`boolean`

**Default:**
```nix
true
```

**Example:**

```nix
true
```

**Declared by:**

- [integrations/treefmt, via option flake.flakeModules.integrations](modules/integrations/treefmt)


## pkgs
**Location:** perSystem.snow-blower.integrations.treefmt.pkgs

Nixpkgs to use in `treefmt`.


**Type:**

`lazy attribute set of raw value`

**Default:**
```nix
"`pkgs` (module argument of `perSystem`)"
```

**Declared by:**

- [integrations/treefmt, via option flake.flakeModules.integrations](modules/integrations/treefmt)
- [integrations/treefmt, via option flake.flakeModules.integrations](modules/integrations/treefmt)


## projectRoot
**Location:** perSystem.snow-blower.integrations.treefmt.projectRoot

Path to the root of the project on which treefmt operates


**Type:**

`absolute path`

**Default:**
```nix
self
```

**Declared by:**

- [integrations/treefmt, via option flake.flakeModules.integrations](modules/integrations/treefmt)

