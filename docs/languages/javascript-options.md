## Options

### bun.enable

**Location:** *perSystem.snow-blower.languages.javascript.bun.enable*

Whether to enable install bun.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### bun.install.enable

**Location:** *perSystem.snow-blower.languages.javascript.bun.install.enable*

Whether to enable bun install during snow blower initialisation.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### bun.package

**Location:** *perSystem.snow-blower.languages.javascript.bun.package*

The bun package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.bun
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### corepack.enable

**Location:** *perSystem.snow-blower.languages.javascript.corepack.enable*

Whether to enable wrappers for npm, pnpm and Yarn via Node.js Corepack.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### directory

**Location:** *perSystem.snow-blower.languages.javascript.directory*

The JavaScript project's root directory. Defaults to the root of the snow blower project.
Can be an absolute path or one relative to the root of the snow blower project.

**Type:**

`string`

**Default:**

```nix
config.snow-blower.paths.root
```

**Example:**

```nix
"./directory"
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### enable

**Location:** *perSystem.snow-blower.languages.javascript.enable*

Whether to enable tools for JavaScript development.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### npm.enable

**Location:** *perSystem.snow-blower.languages.javascript.npm.enable*

Whether to enable install npm.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### npm.install.enable

**Location:** *perSystem.snow-blower.languages.javascript.npm.install.enable*

Whether to enable npm install during snow blower initialisation.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### npm.package

**Location:** *perSystem.snow-blower.languages.javascript.npm.package*

The Node.js package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.nodejs
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### package

**Location:** *perSystem.snow-blower.languages.javascript.package*

The Node.js package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.nodejs-slim
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### pnpm.enable

**Location:** *perSystem.snow-blower.languages.javascript.pnpm.enable*

Whether to enable install pnpm.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### pnpm.install.enable

**Location:** *perSystem.snow-blower.languages.javascript.pnpm.install.enable*

Whether to enable pnpm install during snow blower initialisation.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### pnpm.package

**Location:** *perSystem.snow-blower.languages.javascript.pnpm.package*

The pnpm package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.nodePackages.pnpm
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### yarn.enable

**Location:** *perSystem.snow-blower.languages.javascript.yarn.enable*

Whether to enable install yarn.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### yarn.install.enable

**Location:** *perSystem.snow-blower.languages.javascript.yarn.install.enable*

Whether to enable yarn install during snow blower initialisation.

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

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)

### yarn.package

**Location:** *perSystem.snow-blower.languages.javascript.yarn.package*

The yarn package to use.

**Type:**

`package`

**Default:**

```nix
pkgs.yarn
```

**Declared by:**

- [languages/javascript, via option flake.flakeModules.languages](https://github.com/use-the-fork/snow-blower/tree/main/modules/languages/javascript/default.nix)
