## Options

### disableExtensions
**Location:** *perSystem.snow-blower.languages.php.disableExtensions*

PHP extensions to disable.


**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### enable
**Location:** *perSystem.snow-blower.languages.php.enable*

Whether to enable tools for PHP development.

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

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### extensions
**Location:** *perSystem.snow-blower.languages.php.extensions*

PHP extensions to enable.


**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### ini
**Location:** *perSystem.snow-blower.languages.php.ini*

PHP.ini directives. Refer to the "List of php.ini directives" of PHP's


**Type:**

`null or strings concatenated with "\n"`

**Default:**
```nix
""
```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### package
**Location:** *perSystem.snow-blower.languages.php.package*

Allows you to [override the default used package](https://nixos.org/manual/nixpkgs/stable/#ssec-php-user-guide)
to adjust the settings or add more extensions. You can find the
extensions using `devenv search 'php extensions'`


**Type:**

`package`

**Default:**
```nix
pkgs.php
```

**Example:**

```nix
pkgs.php.buildEnv {
  extensions = { all, enabled }: with all; enabled ++ [ xdebug ];
  extraConfig = ''
    memory_limit=1G
  '';
};

```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### packages
**Location:** *perSystem.snow-blower.languages.php.packages*

Attribute set of packages including composer

**Type:**

`submodule`

**Default:**
```nix
pkgs
```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)


### packages.composer
**Location:** *perSystem.snow-blower.languages.php.packages.composer*

composer package

**Type:**

`null or package`

**Default:**
```nix
pkgs.phpPackages.composer
```

**Declared by:**

- [languages/php, via option flake.flakeModules.languages](modules/languages/php)

