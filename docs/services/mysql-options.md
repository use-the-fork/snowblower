## Options

### enable
**Location:** *perSystem.snow-blower.services.mysql.enable*

Whether to enable MySQL  service.

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

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### package
**Location:** *perSystem.snow-blower.services.mysql.package*

The package MySQL should use.

**Type:**

`package`

**Default:**
```nix
<derivation mariadb-server-10.11.11>
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.configuration
**Location:** *perSystem.snow-blower.services.mysql.settings.configuration*

MySQL configuration.


**Type:**

`lazy attribute set of lazy attribute set of anything`

**Default:**
```nix
{ }
```

**Example:**

```nix
{
  mysqld = {
    key_buffer_size = "6G";
    table_cache = 1600;
    log-error = "/var/log/mysql_err.log";
    plugin-load-add = [ "server_audit" "ed25519=auth_ed25519" ];
  };
  mysqldump = {
    quick = true;
    max_allowed_packet = "16M";
  };
}

```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.ensureUsers
**Location:** *perSystem.snow-blower.services.mysql.settings.ensureUsers*

Ensures that the specified users exist and have at least the ensured permissions.
The MySQL users will be identified using Unix socket authentication. This authenticates the Unix user with the
same name only, and that without the need for a password.
This option will never delete existing users or remove permissions, especially not when the value of this
option is changed. This means that users created and permissions assigned once through this option or
otherwise have to be removed manually.


**Type:**

`list of (submodule)`

**Default:**
```nix
[ ]
```

**Example:**

```nix
[
  {
    name = "snow";
    ensurePermissions = {
      "snow.*" = "ALL PRIVILEGES";
    };
  }
]

```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.ensureUsers.*.ensurePermissions
**Location:** *perSystem.snow-blower.services.mysql.settings.ensureUsers.*.ensurePermissions*

Permissions to ensure for the user, specified as attribute set.
The attribute names specify the database and tables to grant the permissions for,
separated by a dot. You may use wildcards here.
The attribute values specfiy the permissions to grant.
You may specify one or multiple comma-separated SQL privileges here.
For more information on how to specify the target
and on which privileges exist, see the
[GRANT syntax](https://mariadb.com/kb/en/library/grant/).
The attributes are used as `GRANT ${attrName} ON ${attrValue}`.


**Type:**

`attribute set of string`

**Default:**
```nix
{ }
```

**Example:**

```nix
{
  "database.*" = "ALL PRIVILEGES";
  "*.*" = "SELECT, LOCK TABLES";
}

```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.ensureUsers.*.name
**Location:** *perSystem.snow-blower.services.mysql.settings.ensureUsers.*.name*

Name of the user to ensure.


**Type:**

`string`

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.ensureUsers.*.password
**Location:** *perSystem.snow-blower.services.mysql.settings.ensureUsers.*.password*

Password of the user to ensure.


**Type:**

`null or string`

**Default:**
```nix
null
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.host
**Location:** *perSystem.snow-blower.services.mysql.settings.host*

The host MySQL will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.importTimeZones
**Location:** *perSystem.snow-blower.services.mysql.settings.importTimeZones*

Whether to import tzdata on the first startup of the mysql server


**Type:**

`null or boolean`

**Default:**
```nix
null
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.initialDatabases
**Location:** *perSystem.snow-blower.services.mysql.settings.initialDatabases*

List of database names and their initial schemas that should be used to create databases on the first startup
of MySQL. The schema attribute is optional: If not specified, an empty database is created.


**Type:**

`list of (submodule)`

**Default:**
```nix
[ ]
```

**Example:**

```nix
[
  { name = "foodatabase"; schema = ./foodatabase.sql; }
  { name = "bardatabase"; }
]

```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.initialDatabases.*.name
**Location:** *perSystem.snow-blower.services.mysql.settings.initialDatabases.*.name*

The name of the database to create.


**Type:**

`string`

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.initialDatabases.*.schema
**Location:** *perSystem.snow-blower.services.mysql.settings.initialDatabases.*.schema*

The initial schema of the database; if null (the default),
an empty database is created.


**Type:**

`null or absolute path`

**Default:**
```nix
null
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.port
**Location:** *perSystem.snow-blower.services.mysql.settings.port*

The port MySQL will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
3306
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)


### settings.useDefaultsExtraFile
**Location:** *perSystem.snow-blower.services.mysql.settings.useDefaultsExtraFile*

Whether to use defaults-exta-file for the mysql command instead of defaults-file.
This is useful if you want to provide a config file on the command line.
However this can problematic if you have MySQL installed globaly because its config might leak into your environment.
This option does not affect the mysqld command.


**Type:**

`boolean`

**Default:**
```nix
false
```

**Declared by:**

- [services/mysql, via option flake.flakeModules.services](modules/services/mysql)

