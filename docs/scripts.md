## perSystem

A function from system to flake-like attributes omitting the `<system>`
attribute.

Modules defined here have access to the suboptions and [some convenient
module arguments](../module-arguments.html).

*Type:* module

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)

## perSystem.snow-blower.scripts

A set of scripts available when the environment is active.

*Type:* attribute set of (submodule)

*Default:* `{ }`

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)

## perSystem.snow-blower.scripts.\<name\>.package

The package to use to run the script.

*Type:* package

*Default:* `pkgs.bash`

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)

## perSystem.snow-blower.scripts.\<name\>.description

Description of the script.

*Type:* string

*Default:* `""`

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)

## perSystem.snow-blower.scripts.\<name\>.exec

Shell code to execute when the script is run.

*Type:* string

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)

## perSystem.snow-blower.scripts.\<name\>.just.enable

Include this script in just runner.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [scripts, via option flake.flakeModules.scripts](modules/scripts)
