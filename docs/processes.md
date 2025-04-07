## perSystem

A function from system to flake-like attributes omitting the `<system>`
attribute.

Modules defined here have access to the suboptions and [some convenient
module arguments](../module-arguments.html).

*Type:* module

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.process-compose.package

The process-compose package to use.

*Type:* package

*Default:* `pkgs.process-compose`

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.process-compose.settings.after

Bash code to execute after stopping processes.

*Type:* strings concatenated with “\n”

*Default:* `""`

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.process-compose.settings.before

Bash code to execute before starting processes.

*Type:* strings concatenated with “\n”

*Default:* `""`

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.process-compose.settings.server

Top-level process-compose.yaml options when that implementation is used.

*Type:* attribute set

*Default:*

    {
      version = "0.5";
      unix-socket = "${config.snow-blower.paths.runtime}/pc.sock";
      tui = true;
    }

*Example:*

    {
      log_level = "fatal";
      log_location = "/path/to/combined/output/logfile.log";
      version = "0.5";
    }

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.processes

Processes can be started with `just up` and run in foreground mode.

*Type:* attribute set of (submodule)

*Default:* `{ }`

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.processes.\<name\>.exec

Bash code to run the process.

*Type:* string

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)

## perSystem.snow-blower.processes.\<name\>.process-compose

process-compose.yaml specific process attributes.

Example:
https://github.com/F1bonacc1/process-compose/blob/main/process-compose.yaml\`

Only used when using `process.implementation = "process-compose";`

*Type:* attribute set

*Default:* `{ }`

*Example:*

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

*Declared by:*

- [processes, via option
  flake.flakeModules.processes](modules/processes)
