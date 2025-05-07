## Options

### enable
**Location:** *perSystem.snow-blower.languages.java.enable*

Whether to enable tools for Java development.

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

- languages/java, via option flake.flakeModules.languages


### package
**Location:** *perSystem.snow-blower.languages.java.package*

The package Java should use.

**Type:**

`package`

**Default:**
```nix
<derivation openjdk-21.0.5+11>
```

**Declared by:**

- languages/java, via option flake.flakeModules.languages


### settings.gradle.enable
**Location:** *perSystem.snow-blower.languages.java.settings.gradle.enable*

Whether to enable gradle.

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

- languages/java, via option flake.flakeModules.languages


### settings.gradle.package
**Location:** *perSystem.snow-blower.languages.java.settings.gradle.package*

The Gradle package to use.
The Gradle package by default inherits the JDK from `languages.java.package`.


**Type:**

`package`

**Default:**
```nix
pkgs.gradle.override { java = cfg.package; }
```

**Declared by:**

- languages/java, via option flake.flakeModules.languages


### settings.maven.enable
**Location:** *perSystem.snow-blower.languages.java.settings.maven.enable*

Whether to enable maven.

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

- languages/java, via option flake.flakeModules.languages


### settings.maven.package
**Location:** *perSystem.snow-blower.languages.java.settings.maven.package*

The Maven package to use.
The Maven package by default inherits the JDK from `languages.java.package`.


**Type:**

`package`

**Default:**
```nix
"pkgs.maven.override { jdk = cfg.package; }"
```

**Declared by:**

- languages/java, via option flake.flakeModules.languages

