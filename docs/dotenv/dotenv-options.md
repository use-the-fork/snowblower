## Options

### enable

**Location:** *perSystem.snow-blower.dotenv.enable*

Whether to enable .env integration, doesn't support comments or multiline values..

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

- [integrations/dotenv, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/dotenv/default.nix)

### filename

**Location:** *perSystem.snow-blower.dotenv.filename*

The name of the dotenv file to load, or a list of dotenv files to load in order of precedence.

**Type:**

`string or list of string`

**Default:**

```nix
".env"
```

**Declared by:**

- [integrations/dotenv, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/dotenv/default.nix)
