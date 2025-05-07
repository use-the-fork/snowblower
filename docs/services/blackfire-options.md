## Options

### enable
**Location:** *perSystem.snow-blower.services.blackfire.enable*

Whether to enable Blackfire  service.

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

- services/blackfire, via option flake.flakeModules.services


### package
**Location:** *perSystem.snow-blower.services.blackfire.package*

The package Blackfire should use.

**Type:**

`package`

**Default:**
```nix
<derivation blackfire-2.28.23>
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.client-id
**Location:** *perSystem.snow-blower.services.blackfire.settings.client-id*

Sets the client id used to authenticate with Blackfire.
You can find your personal client-id at <https://blackfire.io/my/settings/credentials>.


**Type:**

`string`

**Default:**
```nix
""
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.client-token
**Location:** *perSystem.snow-blower.services.blackfire.settings.client-token*

Sets the client token used to authenticate with Blackfire.
You can find your personal client-token at <https://blackfire.io/my/settings/credentials>.


**Type:**

`string`

**Default:**
```nix
""
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.enableApm
**Location:** *perSystem.snow-blower.services.blackfire.settings.enableApm*

Whether to enable Enables application performance monitoring, requires special subscription.
.

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

- services/blackfire, via option flake.flakeModules.services


### settings.host
**Location:** *perSystem.snow-blower.services.blackfire.settings.host*

The host Blackfire will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.port
**Location:** *perSystem.snow-blower.services.blackfire.settings.port*

The port Blackfire will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
8307
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.server-id
**Location:** *perSystem.snow-blower.services.blackfire.settings.server-id*

Sets the server id used to authenticate with Blackfire.
You can find your personal server-id at <https://blackfire.io/my/settings/credentials>.


**Type:**

`string`

**Default:**
```nix
""
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services


### settings.server-token
**Location:** *perSystem.snow-blower.services.blackfire.settings.server-token*

Sets the server token used to authenticate with Blackfire.
You can find your personal server-token at <https://blackfire.io/my/settings/credentials>.


**Type:**

`string`

**Default:**
```nix
""
```

**Declared by:**

- services/blackfire, via option flake.flakeModules.services

