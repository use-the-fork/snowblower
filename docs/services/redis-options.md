## Options

### enable

**Location:** *perSystem.snow-blower.services.redis.enable*

Whether to enable Redis service.

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

- [services/redis, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/redis/default.nix)

### package

**Location:** *perSystem.snow-blower.services.redis.package*

The package Redis should use.

**Type:**

`package`

**Default:**

```nix
<derivation redis-7.2.7>
```

**Declared by:**

- [services/redis, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/redis/default.nix)

### settings.extraConfig

**Location:** *perSystem.snow-blower.services.redis.settings.extraConfig*

Additional text to be appended to `redis.conf`.

**Type:**

`strings concatenated with "\n"`

**Default:**

```nix
"locale-collate C"
```

**Declared by:**

- [services/redis, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/redis/default.nix)

### settings.host

**Location:** *perSystem.snow-blower.services.redis.settings.host*

The host Redis will listen on

**Type:**

`string`

**Default:**

```nix
"127.0.0.1"
```

**Declared by:**

- [services/redis, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/redis/default.nix)

### settings.port

**Location:** *perSystem.snow-blower.services.redis.settings.port*

The port Redis will listen on

**Type:**

`signed integer or string`

**Default:**

```nix
6379
```

**Declared by:**

- [services/redis, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/redis/default.nix)
