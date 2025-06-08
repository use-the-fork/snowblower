## Options

### enable

**Location:** *perSystem.snow-blower.services.adminer.enable*

Whether to enable Adminer service.

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

- [services/adminer, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/adminer/default.nix)

### package

**Location:** *perSystem.snow-blower.services.adminer.package*

The package Adminer should use.

**Type:**

`package`

**Default:**

```nix
<derivation adminer-5.1.1>
```

**Declared by:**

- [services/adminer, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/adminer/default.nix)

### settings.host

**Location:** *perSystem.snow-blower.services.adminer.settings.host*

The host Adminer will listen on

**Type:**

`string`

**Default:**

```nix
"127.0.0.1"
```

**Declared by:**

- [services/adminer, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/adminer/default.nix)

### settings.port

**Location:** *perSystem.snow-blower.services.adminer.settings.port*

The port Adminer will listen on

**Type:**

`signed integer or string`

**Default:**

```nix
8080
```

**Declared by:**

- [services/adminer, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/adminer/default.nix)
