## Options

### bundler.enable
**Location:** *perSystem.snow-blower.languages.ruby.bundler.enable*

Whether to enable bundler.

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

- [languages/ruby, via option flake.flakeModules.languages](modules/languages/ruby)


### bundler.package
**Location:** *perSystem.snow-blower.languages.ruby.bundler.package*

The bundler package to use.

**Type:**

`package`

**Default:**
```nix
pkgs.bundler.override { ruby = cfg.package; }
```

**Declared by:**

- [languages/ruby, via option flake.flakeModules.languages](modules/languages/ruby)


### enable
**Location:** *perSystem.snow-blower.languages.ruby.enable*

Whether to enable tools for Ruby development.

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

- [languages/ruby, via option flake.flakeModules.languages](modules/languages/ruby)


### package
**Location:** *perSystem.snow-blower.languages.ruby.package*

The Ruby package to use.

**Type:**

`package`

**Default:**
```nix
pkgs.ruby
```

**Declared by:**

- [languages/ruby, via option flake.flakeModules.languages](modules/languages/ruby)

