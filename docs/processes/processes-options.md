## Options

### processes
**Location:** *perSystem.snow-blower.processes*

Processes can be started with ``just up`` and run in foreground mode.

**Type:**

`attribute set of (submodule)`

**Default:**
```nix
{ }
```

**Declared by:**

- processes, via option flake.flakeModules.processes


### exec
**Location:** *perSystem.snow-blower.processes.\<name\>.exec*

Bash code to run the process.

**Type:**

`string`

**Declared by:**

- processes, via option flake.flakeModules.processes


### process-compose
**Location:** *perSystem.snow-blower.processes.\<name\>.process-compose*

process-compose.yaml specific process attributes.

Example: https://github.com/F1bonacc1/process-compose/blob/main/process-compose.yaml`

Only used when using ``process.implementation = "process-compose";``


**Type:**

`attribute set`

**Default:**
```nix
{ }
```

**Example:**

```nix
{
  availability = {
    backoff_seconds = 2;
    max_restarts = 5;
    restart = "on_failure";
  };
  depends_on = {
    some-other-process = {
      condition = "process_completed_successfully";
    };
  };
  environment = [
    "ENVVAR_FOR_THIS_PROCESS_ONLY=foobar"
  ];
}
```

**Declared by:**

- processes, via option flake.flakeModules.processes

