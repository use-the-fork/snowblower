## Options

### enable
**Location:** *perSystem.snow-blower.integrations.convco.enable*

Whether to enable Convco just command.

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

- [integrations/convco, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/convco/default.nix)


### package
**Location:** *perSystem.snow-blower.integrations.convco.package*

The package Convco should use.

**Type:**

`package`

**Default:**
```nix
<derivation convco-0.6.1>
```

**Declared by:**

- [integrations/convco, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/convco/default.nix)


### settings.file-name
**Location:** *perSystem.snow-blower.integrations.convco.settings.file-name*

The name of the file to output the chaneglog to.

**Type:**

`string`

**Default:**
```nix
"CHANGELOG.md"
```

**Declared by:**

- [integrations/convco, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/convco/default.nix)

