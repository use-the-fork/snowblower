## perSystem

A function from system to flake-like attributes omitting the `<system>`
attribute.

Modules defined here have access to the suboptions and [some convenient
module arguments](../module-arguments.html).

*Type:* module

*Declared by:*

- [integrations/git-hooks/hooks/commitlint.nix, via option
  flake.flakeModules.integrations](modules/integrations/git-hooks/hooks/commitlint.nix)
- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)
- [integrations/git-hooks, via option
  flake.flakeModules.integrations](modules/integrations/git-hooks)
- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)
- [integrations/snow-blower, via option
  flake.flakeModules.integrations](modules/integrations/snow-blower)
- [integrations/dotenv, via option
  flake.flakeModules.integrations](modules/integrations/dotenv)
- [integrations/convco, via option
  flake.flakeModules.integrations](modules/integrations/convco)
- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.dotenv.enable

Whether to enable .env integration, doesn’t support comments or
multiline values…

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [integrations/dotenv, via option
  flake.flakeModules.integrations](modules/integrations/dotenv)

## perSystem.snow-blower.dotenv.filename

The name of the dotenv file to load, or a list of dotenv files to load
in order of precedence.

*Type:* string or list of string

*Default:* `".env"`

*Declared by:*

- [integrations/dotenv, via option
  flake.flakeModules.integrations](modules/integrations/dotenv)

## perSystem.snow-blower.integrations.agenix.enable

Whether to enable Agenix .env Integration.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.package

The package agenix should use.

*Type:* package

*Default:* `<derivation agenix-0.15.0>`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.secrets

Attrset of secrets.

*Type:* attribute set of (submodule)

*Example:*

    {
      ".env.local" = {
        publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"];
      };
    }

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.secrets.\<name\>.file

Age file the secret is loaded from. Relative to flake root.

*Type:* string

*Default:* `"secrets/‹name›.age"`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.secrets.\<name\>.mode

Permissions mode of the decrypted secret in a format understood by
chmod.

*Type:* string

*Default:* `"0644"`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.secrets.\<name\>.name

Name of the Env file containing the secrets.

*Type:* unspecified value

*Default:* `<name>`

*Example:* `.env.local`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.agenix.secrets.\<name\>.publicKeys

A list of public keys that are used to encrypt the secret.

*Type:* list of string

*Default:* `[ ]`

*Example:*
`["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi"]`

*Declared by:*

- [integrations/agenix, via option
  flake.flakeModules.integrations](modules/integrations/agenix)

## perSystem.snow-blower.integrations.convco.enable

Whether to enable Convco just command.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [integrations/convco, via option
  flake.flakeModules.integrations](modules/integrations/convco)

## perSystem.snow-blower.integrations.convco.package

The package Convco should use.

*Type:* package

*Default:* `<derivation convco-0.6.1>`

*Declared by:*

- [integrations/convco, via option
  flake.flakeModules.integrations](modules/integrations/convco)

## perSystem.snow-blower.integrations.convco.settings.file-name

The name of the file to output the chaneglog to.

*Type:* string

*Default:* `"CHANGELOG.md"`

*Declared by:*

- [integrations/convco, via option
  flake.flakeModules.integrations](modules/integrations/convco)

## perSystem.snow-blower.integrations.git-cliff.enable

Whether to enable Git-Cliff just command.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)

## perSystem.snow-blower.integrations.git-cliff.package

The package Git-Cliff should use.

*Type:* package

*Default:* `<derivation git-cliff-2.8.0>`

*Declared by:*

- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)

## perSystem.snow-blower.integrations.git-cliff.settings.config-file

The git-cliff config to use.

See https://git-cliff.org/docs/configuration/

*Type:* string

*Default:*

    ''
      [changelog]
      header = """
      # Changelog\n
      All notable changes to this project will be documented in this file.\n
      """
      body = """
      {% if version %}\
          ## [{{ version | trim_start_matches(pat="v") }}] - {{ timestamp | date(format="%Y-%m-%d") }}
      {% else %}\
          ## [unreleased]
      {% endif %}\
      {% for group, commits in commits | group_by(attribute="group") %}
          ### {{ group | striptags | trim | upper_first }}
          {% for commit in commits %}
              - {% if commit.scope %}*({{ commit.scope }})* {% endif %}\
                  {% if commit.breaking %}[**breaking**] {% endif %}\
                  {{ commit.message | upper_first }}\
          {% endfor %}
      {% endfor %}\n
      """
      # template for the changelog footer
      footer = """
      <!-- generated by git-cliff -->
      """
      # remove the leading and trailing s
      trim = true
      
      [git]
      conventional_commits = true
      filter_unconventional = true
      split_commits = false
      commit_parsers = [
        { message = "^feat", group = "<!-- 0 -->🚀 Features" },
        { message = "^fix", group = "<!-- 1 -->🐛 Bug Fixes" },
        { message = "^doc", group = "<!-- 3 -->📚 Documentation" },
        { message = "^perf", group = "<!-- 4 -->⚡ Performance" },
        { message = "^refactor", group = "<!-- 2 -->🚜 Refactor" },
        { message = "^style", group = "<!-- 5 -->🎨 Styling" },
        { message = "^test", group = "<!-- 6 -->🧪 Testing" },
        { message = "^chore\\(release\\): prepare for", skip = true },
        { message = "^chore\\(deps.*\\)", skip = true },
        { message = "^chore\\(pr\\)", skip = true },
        { message = "^chore\\(pull\\)", skip = true },
        { message = "^chore|^ci", group = "<!-- 7 -->⚙️ Miscellaneous Tasks" },
        { body = ".*security", group = "<!-- 8 -->🛡️ Security" },
        { message = "^revert", group = "<!-- 9 -->◀️ Revert" },
      ]
      protect_breaking_commits = false
      filter_commits = false
      topo_order = false
      sort_commits = "oldest"
    ''

*Declared by:*

- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)

## perSystem.snow-blower.integrations.git-cliff.settings.file-name

The name of the file to output the chaneglog to.

*Type:* string

*Default:* `"CHANGELOG.md"`

*Declared by:*

- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)

## perSystem.snow-blower.integrations.git-cliff.settings.integrations.github.enable

Whether to enable Enable the GitHub integration. See
https://git-cliff.org/docs/integration/github.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [integrations/git-cliff, via option
  flake.flakeModules.integrations](modules/integrations/git-cliff)

## perSystem.snow-blower.integrations.git-hooks

Integration of https://github.com/cachix/git-hooks.nix

*Type:* submodule

*Default:* `{ }`

*Declared by:*

- [integrations/git-hooks, via option
  flake.flakeModules.integrations](modules/integrations/git-hooks)

## perSystem.snow-blower.integrations.treefmt

Integration of https://github.com/numtide/treefmt-nix

*Type:* submodule

*Default:* `{ }`

*Declared by:*

- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)

## perSystem.snow-blower.integrations.treefmt.just.enable

Whether to enable enable just command.

*Type:* boolean

*Default:* `true`

*Example:* `true`

*Declared by:*

- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)

## perSystem.snow-blower.integrations.treefmt.pkgs

Nixpkgs to use in `treefmt`.

*Type:* lazy attribute set of raw value

*Default:* `` "`pkgs` (module argument of `perSystem`)" ``

*Declared by:*

- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)
- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)

## perSystem.snow-blower.integrations.treefmt.projectRoot

Path to the root of the project on which treefmt operates

*Type:* absolute path

*Default:* `self`

*Declared by:*

- [integrations/treefmt, via option
  flake.flakeModules.integrations](modules/integrations/treefmt)
