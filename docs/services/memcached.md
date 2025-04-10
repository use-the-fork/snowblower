# Memcached (services)

Options for configuring memcached in the services category.

## enable
**Location:** perSystem.snow-blower.services.memcached.enable

Whether to enable Memcached  service.

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

- [services/memcached, via option flake.flakeModules.services](modules/services/memcached)


## package
**Location:** perSystem.snow-blower.services.memcached.package

The package Memcached should use.

**Type:**

`package`

**Default:**
```nix
<derivation memcached-1.6.35>
```

**Declared by:**

- [services/memcached, via option flake.flakeModules.services](modules/services/memcached)


## settings.host
**Location:** perSystem.snow-blower.services.memcached.settings.host

The host Memcached will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/memcached, via option flake.flakeModules.services](modules/services/memcached)


## settings.port
**Location:** perSystem.snow-blower.services.memcached.settings.port

The port Memcached will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
11211
```

**Declared by:**

- [services/memcached, via option flake.flakeModules.services](modules/services/memcached)


## settings.startArgs
**Location:** perSystem.snow-blower.services.memcached.settings.startArgs

Additional arguments passed to `memcached` during startup.


**Type:**

`list of strings concatenated with "\n"`

**Default:**
```nix
[ ]
```

**Example:**

```nix
[
  "--memory-limit=100M"
]
```

**Declared by:**

- [services/memcached, via option flake.flakeModules.services](modules/services/memcached)

