## Options

### enable
**Location:** *perSystem.snow-blower.services.aider.enable*

Whether to enable Aider  service.

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

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### package
**Location:** *perSystem.snow-blower.services.aider.package*

The package Aider should use.

**Type:**

`package`

**Default:**
```nix
<derivation aider-chat-0.81.0>
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.auto-commits
**Location:** *perSystem.snow-blower.services.aider.settings.auto-commits*

Enable/disable auto commit of LLM changes.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.auto-lint
**Location:** *perSystem.snow-blower.services.aider.settings.auto-lint*

Enable/disable automatic linting after changes

**Type:**

`boolean`

**Default:**
```nix
true
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.cache-prompts
**Location:** *perSystem.snow-blower.services.aider.settings.cache-prompts*

Enable caching of prompts.

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.code-theme
**Location:** *perSystem.snow-blower.services.aider.settings.code-theme*

Set the markdown code theme

**Type:**

`one of "default", "monokai", "solarized-dark", "solarized-light"`

**Default:**
```nix
"default"
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.dark-mode
**Location:** *perSystem.snow-blower.services.aider.settings.dark-mode*

Use colors suitable for a dark terminal background.

**Type:**

`boolean`

**Default:**
```nix
true
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.dirty-commits
**Location:** *perSystem.snow-blower.services.aider.settings.dirty-commits*

Enable/disable commits when repo is found dirty

**Type:**

`boolean`

**Default:**
```nix
true
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.edit-format
**Location:** *perSystem.snow-blower.services.aider.settings.edit-format*

Set the markdown code theme

**Type:**

`one of "whole", "diff", "diff-fenced", "udiff"`

**Default:**
```nix
"diff"
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.extraConf
**Location:** *perSystem.snow-blower.services.aider.settings.extraConf*

Extra configuration for aider, see
<link xlink:href="See settings here: https://aider.chat/docs/config/aider_conf.html"/>
for supported values.


**Type:**

`YAML value`

**Default:**
```nix
{ }
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.host
**Location:** *perSystem.snow-blower.services.aider.settings.host*

The host Aider will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.light-mode
**Location:** *perSystem.snow-blower.services.aider.settings.light-mode*

Use colors suitable for a light terminal background

**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.model
**Location:** *perSystem.snow-blower.services.aider.settings.model*

Specify the model to use for the main chat.

**Type:**

`string`

**Default:**
```nix
"sonnet"
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)


### settings.port
**Location:** *perSystem.snow-blower.services.aider.settings.port*

The port Aider will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
0
```

**Declared by:**

- [services/aider, via option flake.flakeModules.services](https://github.com/use-the-fork/snow-blower/tree/main/modules/services/aider/default.nix)

