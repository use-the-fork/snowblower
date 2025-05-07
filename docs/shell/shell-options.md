## Options

### devShell
**Location:** *perSystem.snow-blower.shell.build.devShell*

The development shell with Snow Blower and its underlying programs

**Type:**

`package`

**Declared by:**

- shell, via option flake.flakeModules.shell


### interactive
**Location:** *perSystem.snow-blower.shell.interactive*

Bash code to execute on interactive startups

**Type:**

`list of string`

**Default:**
```nix
""
```

**Declared by:**

- shell, via option flake.flakeModules.shell


### motd
**Location:** *perSystem.snow-blower.shell.motd*

Message Of The Day.

This is the welcome message that is being printed when the user opens
the shell.

You may use any valid ansi color from the 8-bit ansi color table. For example, to use a green color you would use something like {106}. You may also use {bold}, {italic}, {underline}. Use {reset} to turn off all attributes.


**Type:**

`string`

**Default:**
```nix
''
  ❄️ 💨 Snow Blower: All flake no fluff.
''
```

**Declared by:**

- shell, via option flake.flakeModules.shell


### startup
**Location:** *perSystem.snow-blower.shell.startup*

Bash code to execute on startup.

**Type:**

`list of string`

**Default:**
```nix
""
```

**Declared by:**

- shell, via option flake.flakeModules.shell


### stdenv
**Location:** *perSystem.snow-blower.shell.stdenv*

The stdenv to use for the developer environment.

**Type:**

`package`

**Default:**
```nix
<derivation stdenv-linux>
```

**Declared by:**

- shell, via option flake.flakeModules.shell

