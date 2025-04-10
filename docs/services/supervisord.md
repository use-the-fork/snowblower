# Supervisord (services)

Options for configuring supervisord in the services category.

## enable
**Location:** perSystem.snow-blower.services.supervisord.enable

Whether to enable Supervisor  service.

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

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## package
**Location:** perSystem.snow-blower.services.supervisord.package

The package Supervisor should use.

**Type:**

`package`

**Default:**
```nix
<derivation python3.12-supervisor-4.2.5>
```

**Declared by:**

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## programs
**Location:** perSystem.snow-blower.services.supervisord.programs

Configuration for each program.

**Type:**

`attribute set of (submodule)`

**Default:**
```nix
{ }
```

**Declared by:**

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## programs.\<name\>.enable
**Location:** perSystem.snow-blower.services.supervisord.programs.\<name\>.enable

Whether to enable Enable this program.

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

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## programs.\<name\>.program
**Location:** perSystem.snow-blower.services.supervisord.programs.\<name\>.program

The program configuration. See http://supervisord.org/configuration.html#program-x-section-settings

**Type:**

`strings concatenated with "\n"`

**Declared by:**

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## settings.host
**Location:** perSystem.snow-blower.services.supervisord.settings.host

The host Supervisor will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)


## settings.port
**Location:** perSystem.snow-blower.services.supervisord.settings.port

The port Supervisor will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
0
```

**Declared by:**

- [services/supervisord, via option flake.flakeModules.services](modules/services/supervisord)

