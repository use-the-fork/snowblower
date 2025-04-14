## Options

### package
**Location:** *perSystem.snow-blower.process-compose.package*

The process-compose package to use.

**Type:**

`package`

**Default:**
```nix
pkgs.process-compose
```

**Declared by:**

- [processes, via option flake.flakeModules.processes](modules/processes)


### after
**Location:** *perSystem.snow-blower.process-compose.settings.after*

Bash code to execute after stopping processes.

**Type:**

`strings concatenated with "\n"`

**Default:**
```nix
""
```

**Declared by:**

- [processes, via option flake.flakeModules.processes](modules/processes)


### before
**Location:** *perSystem.snow-blower.process-compose.settings.before*

Bash code to execute before starting processes.

**Type:**

`strings concatenated with "\n"`

**Default:**
```nix
""
```

**Declared by:**

- [processes, via option flake.flakeModules.processes](modules/processes)


### server
**Location:** *perSystem.snow-blower.process-compose.settings.server*

Top-level process-compose.yaml options when that implementation is used.


**Type:**

`attribute set`

**Default:**
```nix
{
  version = "0.5";
  unix-socket = "${config.snow-blower.paths.runtime}/pc.sock";
  tui = true;
}

```

**Example:**

```nix
{
  log_level = "fatal";
  log_location = "/path/to/combined/output/logfile.log";
  version = "0.5";
}
```

**Declared by:**

- [processes, via option flake.flakeModules.processes](modules/processes)

