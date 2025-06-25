## Options

### enable

**Location:** *perSystem.snow-blower.integrations.agenix.enable*

Whether to enable Agenix .env Integration.

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

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### package

**Location:** *perSystem.snow-blower.integrations.agenix.package*

The package agenix should use.

**Type:**

`package`

**Default:**

```nix
<derivation agenix-0.15.0>
```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### secrets

**Location:** *perSystem.snow-blower.integrations.agenix.secrets*

Attrset of secrets.

**Type:**

`attribute set of (submodule)`

**Example:**

```nix
{
  ".env.local" = {
    publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"];
  };
}

```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### secrets.\<name>.file

**Location:** *perSystem.snow-blower.integrations.agenix.secrets.\<name>.file*

Age file the secret is loaded from. Relative to flake root.

**Type:**

`string`

**Default:**

```nix
"secrets/‹name›.age"
```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### secrets.\<name>.mode

**Location:** *perSystem.snow-blower.integrations.agenix.secrets.\<name>.mode*

Permissions mode of the decrypted secret in a format understood by chmod.

**Type:**

`string`

**Default:**

```nix
"0644"
```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### secrets.\<name>.name

**Location:** *perSystem.snow-blower.integrations.agenix.secrets.\<name>.name*

Name of the Env file containing the secrets.

**Type:**

`unspecified value`

**Default:**

```nix
<name>
```

**Example:**

```nix
.env.local
```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)

### secrets.\<name>.publicKeys

**Location:** *perSystem.snow-blower.integrations.agenix.secrets.\<name>.publicKeys*

A list of public keys that are used to encrypt the secret.

**Type:**

`list of string`

**Default:**

```nix
[ ]
```

**Example:**

```nix
["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"]
```

**Declared by:**

- [integrations/agenix, via option flake.flakeModules.integrations](https://github.com/use-the-fork/snow-blower/tree/main/modules/integrations/agenix/default.nix)
