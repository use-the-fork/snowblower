## Options

### commands

**Location:** *perSystem.snow-blower.integrations.aider.commands*

The aider start commands that we can run with just.

**Type:**

`attribute set of (submodule)`

**Default:**

```nix
{ }
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### commands.\<name>.description

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.description*

Description of this Aider command

**Type:**

`string`

**Default:**

```nix
"Run Aider AI assistant"
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.detectUrls

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.detectUrls*

Enable/disable detection and offering to add URLs to chat

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.enable

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.enable*

Whether to enable this command.

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

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.extraArgs

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.extraArgs*

Extra command line arguments to pass to Aider

**Type:**

`string`

**Default:**

```nix
""
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.gitCommitVerify

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.gitCommitVerify*

Enable git pre-commit hooks with --git-commit-verify

**Type:**

`boolean`

**Default:**

```nix
true
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.lintCommands

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.lintCommands*

Specify lint commands to run for different languages, eg: 'python: flake8 --select=...'

**Type:**

`list of string`

**Default:**

```nix
[ ]
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.model

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.model*

Specify the model to use for the main chat.

**Type:**

`string`

**Default:**

```nix
"sonnet"
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.readFiles

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.readFiles*

Specify read-only files (can be used multiple times)

**Type:**

`list of string`

**Default:**

```nix
[ ]
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.suggestShellCommands

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.suggestShellCommands*

Enable/disable suggesting shell commands

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.testCommands

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.testCommands*

Specify commands to run tests

**Type:**

`list of string`

**Default:**

```nix
[ ]
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### commands.\<name>.watchFiles

**Location:** *perSystem.snow-blower.integrations.aider.commands.\<name>.watchFiles*

Enable watching files for changes

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider/command-module.nix](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/command-module.nix)

### enable

**Location:** *perSystem.snow-blower.integrations.aider.enable*

Whether to enable Aider just command.

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

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### package

**Location:** *perSystem.snow-blower.integrations.aider.package*

The package Aider should use.

**Type:**

`package`

**Default:**

```nix
<derivation aider-chat-0.82.1>
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.auto-commits

**Location:** *perSystem.snow-blower.integrations.aider.settings.auto-commits*

Enable/disable auto commit of LLM changes.

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.auto-lint

**Location:** *perSystem.snow-blower.integrations.aider.settings.auto-lint*

Enable/disable automatic linting after changes

**Type:**

`boolean`

**Default:**

```nix
true
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.cache-prompts

**Location:** *perSystem.snow-blower.integrations.aider.settings.cache-prompts*

Enable caching of prompts.

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.code-theme

**Location:** *perSystem.snow-blower.integrations.aider.settings.code-theme*

Set the markdown code theme

**Type:**

`one of "default", "monokai", "solarized-dark", "solarized-light"`

**Default:**

```nix
"default"
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.dark-mode

**Location:** *perSystem.snow-blower.integrations.aider.settings.dark-mode*

Use colors suitable for a dark terminal background.

**Type:**

`boolean`

**Default:**

```nix
true
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.dirty-commits

**Location:** *perSystem.snow-blower.integrations.aider.settings.dirty-commits*

Enable/disable commits when repo is found dirty

**Type:**

`boolean`

**Default:**

```nix
true
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.edit-format

**Location:** *perSystem.snow-blower.integrations.aider.settings.edit-format*

Set the markdown code theme

**Type:**

`one of "whole", "diff", "diff-fenced", "udiff"`

**Default:**

```nix
"diff"
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.extraConf

**Location:** *perSystem.snow-blower.integrations.aider.settings.extraConf*

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

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)

### settings.light-mode

**Location:** *perSystem.snow-blower.integrations.aider.settings.light-mode*

Use colors suitable for a light terminal background

**Type:**

`boolean`

**Default:**

```nix
false
```

**Declared by:**

- [integrations/aider, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/aider/default.nix)
