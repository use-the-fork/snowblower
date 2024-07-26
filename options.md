## perSystem

A function from system to flake-like attributes omitting the ` <system> ` attribute\.

Modules defined here have access to the suboptions and [some convenient module arguments](\.\./module-arguments\.html)\.



*Type:*
module

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)
 - [services/adminer, via option flake\.flakeModules\.services](modules/services/adminer)
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)
 - [processes, via option flake\.flakeModules\.processes](modules/processes)
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)
 - [integrations/git-hooks, via option flake\.flakeModules\.integrations](modules/integrations/git-hooks)
 - [integrations/treefmt, via option flake\.flakeModules\.integrations](modules/integrations/treefmt)
 - [integrations/dotenv, via option flake\.flakeModules\.integrations](modules/integrations/dotenv)
 - [integrations/convco, via option flake\.flakeModules\.integrations](modules/integrations/convco)
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)
 - [just, via option flake\.flakeModules\.just](modules/just)
 - [env, via option flake\.flakeModules\.env](modules/env)
 - [core/nixpkgs\.nix, via option flake\.flakeModules\.nixpkgs](modules/core/nixpkgs.nix)
 - [options-document\.nix](modules/options-document.nix)



## perSystem\.snow-blower\.ai\.laravel\.enable



Whether to enable Laravel ai command\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.laravel\.prompt\.examples



A good prompt should always be a few shot or multi shot prompt\.



*Type:*
strings concatenated with “\\n”



*Default:*

```
''
  user: a command that sends emails.
          response: php artisan make:command SendEmails
  
           user: a model for flights include the migration
           response: php artisan make:model Flight --migration
  
           user: a model for flights include the migration resource and request
           response: php artisan make:model Flight --controller --resource --requests
  
           user: Flight model overview
           response: php artisan model:show Flight
  
           user: Flight controller
           response: php artisan make:controller FlightController
  
           user: erase and reseed the database forefully
           response: php artisan migrate:fresh --seed --force
  
           user: what routes are avliable?
           response: php artisan route:list
  
           user: rollback migrations 5 times
           response: php artisan migrate:rollback --step=5
  
           user: start a q worker
           response: php artisan queue:work''
```

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.laravel\.prompt\.message



The system message that will be used at the start of the prompt\.



*Type:*
strings concatenated with “\\n”



*Default:*

```
''
  You are a helpful assistant trained to generate Laravel commands based on the users request.
          Only respond with the laravel command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.''
```

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.laravel\.settings\.maxTokens



The maximum number of tokens that can be generated in the chat completion\. The total length of input tokens and generated tokens is limited by the model’s context length\.



*Type:*
null or signed integer



*Default:*
` null `

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.laravel\.settings\.model



The name of the dotenv file to load, or a list of dotenv files to load in order of precedence\.



*Type:*
one of “gpt-4-turbo”, “gpt-4o”, “gpt-4o-mini”



*Default:*
` "gpt-4-turbo" `

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.laravel\.settings\.temperature



What sampling temperature to use, between 0 and 2\. Higher values like 0\.8 will make the output more random, while lower values like 0\.2 will make it more focused and deterministic\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [ai/laravel\.nix, via option flake\.flakeModules\.ai](modules/ai/laravel.nix)



## perSystem\.snow-blower\.ai\.nix\.enable



Whether to enable NIX ai command\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.ai\.nix\.prompt\.examples



A good prompt should always be a few shot or multi shot prompt\.



*Type:*
strings concatenated with “\\n”



*Default:*

```
''
  user: show the outputs provided by my flake
          response: nix flake show
  
           user: update flake lock file
           response: nix flake update
  
           user: build my foo package
           response: nix build .#foo
  
           user: garbage collect anything older then 3 days
           response: sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d
  
           user: list all of my systems generations
           response: sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
  
           user: repair the nix store
           response: nix-store --verify --check-contents --repair''
```

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.ai\.nix\.prompt\.message



The system message that will be used at the start of the prompt\.



*Type:*
strings concatenated with “\\n”



*Default:*

```
''
  You are a helpful assistant trained to generate Nix commands based on the users request.
          Only respond with the nix command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.''
```

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.ai\.nix\.settings\.maxTokens



The maximum number of tokens that can be generated in the chat completion\. The total length of input tokens and generated tokens is limited by the model’s context length\.



*Type:*
null or signed integer



*Default:*
` null `

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.ai\.nix\.settings\.model



The name of the dotenv file to load, or a list of dotenv files to load in order of precedence\.



*Type:*
one of “gpt-4-turbo”, “gpt-4o”, “gpt-4o-mini”



*Default:*
` "gpt-4-turbo" `

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.ai\.nix\.settings\.temperature



What sampling temperature to use, between 0 and 2\. Higher values like 0\.8 will make the output more random, while lower values like 0\.2 will make it more focused and deterministic\.



*Type:*
signed integer



*Default:*
` 1 `

*Declared by:*
 - [ai/nix-flake\.nix, via option flake\.flakeModules\.ai](modules/ai/nix-flake.nix)



## perSystem\.snow-blower\.dotenv\.enable



Whether to enable \.env integration, doesn’t support comments or multiline values…



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [integrations/dotenv, via option flake\.flakeModules\.integrations](modules/integrations/dotenv)



## perSystem\.snow-blower\.dotenv\.filename



The name of the dotenv file to load, or a list of dotenv files to load in order of precedence\.



*Type:*
string or list of string



*Default:*
` ".env" `

*Declared by:*
 - [integrations/dotenv, via option flake\.flakeModules\.integrations](modules/integrations/dotenv)



## perSystem\.snow-blower\.env



Environment variables to be exposed inside the developer environment\.



*Type:*
lazy attribute set of anything



*Default:*
` { } `

*Declared by:*
 - [env, via option flake\.flakeModules\.env](modules/env)



## perSystem\.snow-blower\.integrations\.agenix\.enable



Whether to enable Agenix Integration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.package



The age package to use\.



*Type:*
package



*Default:*
` pkgs.rage `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.flakeName



Command returning the name of the flake, used as part of the secrets path\.



*Type:*
string



*Default:*
` "git rev-parse --show-toplevel | xargs basename" `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.identityPaths



Path to SSH keys to be used as identities in age decryption\.



*Type:*
list of string



*Default:*

```
[
  "$HOME/.ssh/id_ed25519"
  "$HOME/.ssh/id_rsa"
]
```

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.keys



Attrset of public keys\.



*Type:*
attribute set of (submodule)



*Example:*

```
{
  user1.key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
}

```

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.keys\.\<name>\.key



The public key used to encrypt the secrets



*Type:*
string



*Example:*
` "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDpVA+jisOuuNDeCJ67M11qUP8YY29cipajWzTFAobi" `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.keys\.\<name>\.name



Name of the variable containing the public key\.



*Type:*
unspecified value



*Default:*
` <name> `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets



Attrset of secrets\.



*Type:*
attribute set of (submodule)



*Example:*

```
{
  foo.file = "secrets/foo.age";
  bar = {
    file = "secrets/bar.age";
    mode = "0440";
  };
}

```

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets\.\<name>\.file



Age file the secret is loaded from\.



*Type:*
path

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets\.\<name>\.mode



Permissions mode of the decrypted secret in a format understood by chmod\.



*Type:*
string



*Default:*
` "0400" `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets\.\<name>\.name



Name of the variable containing the secret\.



*Type:*
unspecified value



*Default:*
` <name> `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets\.\<name>\.namePath



Name of the variable containing the path to the secret\.



*Type:*
unspecified value



*Default:*
` <name>_PATH `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secrets\.\<name>\.path



Path where the decrypted secret is installed\.



*Type:*
string



*Default:*
` "${config.agenix-shell.secretsPath}/<name>" `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.agenix\.secretsPath



Where the secrets are stored\.



*Type:*
string



*Default:*
` "/run/user/$(id -u)/agenix-shell/$(${config.agenix-shell.flakeName})/$(uuidgen)" `

*Declared by:*
 - [integrations/agenix, via option flake\.flakeModules\.integrations](modules/integrations/agenix)



## perSystem\.snow-blower\.integrations\.convco\.enable



Whether to enable Convco just command\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [integrations/convco, via option flake\.flakeModules\.integrations](modules/integrations/convco)



## perSystem\.snow-blower\.integrations\.convco\.package



The package Convco should use\.



*Type:*
package



*Default:*
` <derivation convco-0.5.1> `

*Declared by:*
 - [integrations/convco, via option flake\.flakeModules\.integrations](modules/integrations/convco)



## perSystem\.snow-blower\.integrations\.convco\.settings\.file-name



The name of the file to output the chaneglog to\.



*Type:*
string



*Default:*
` "CHANGELOG.md" `

*Declared by:*
 - [integrations/convco, via option flake\.flakeModules\.integrations](modules/integrations/convco)



## perSystem\.snow-blower\.integrations\.git-cliff\.enable



Whether to enable Git-Cliff just command\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)



## perSystem\.snow-blower\.integrations\.git-cliff\.package



The package Git-Cliff should use\.



*Type:*
package



*Default:*
` <derivation git-cliff-2.4.0> `

*Declared by:*
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)



## perSystem\.snow-blower\.integrations\.git-cliff\.settings\.config-file



The git-cliff config to use\.

See https://git-cliff\.org/docs/configuration/



*Type:*
string



*Default:*

```
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
```

*Declared by:*
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)



## perSystem\.snow-blower\.integrations\.git-cliff\.settings\.file-name



The name of the file to output the chaneglog to\.



*Type:*
string



*Default:*
` "CHANGELOG.md" `

*Declared by:*
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)



## perSystem\.snow-blower\.integrations\.git-cliff\.settings\.integrations\.github\.enable



Whether to enable Enable the GitHub integration\. See https://git-cliff\.org/docs/integration/github\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [integrations/git-cliff, via option flake\.flakeModules\.integrations](modules/integrations/git-cliff)



## perSystem\.snow-blower\.integrations\.git-hooks



Integration of https://github\.com/cachix/git-hooks\.nix



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [integrations/git-hooks, via option flake\.flakeModules\.integrations](modules/integrations/git-hooks)



## perSystem\.snow-blower\.integrations\.treefmt



Integration of https://github\.com/numtide/treefmt-nix



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [integrations/treefmt, via option flake\.flakeModules\.integrations](modules/integrations/treefmt)



## perSystem\.snow-blower\.integrations\.treefmt\.just\.enable



Whether to enable enable just command\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `

*Declared by:*
 - [integrations/treefmt, via option flake\.flakeModules\.integrations](modules/integrations/treefmt)



## perSystem\.snow-blower\.integrations\.treefmt\.pkgs



Nixpkgs to use in ` treefmt `\.



*Type:*
lazy attribute set of raw value

*Declared by:*
 - [integrations/treefmt, via option flake\.flakeModules\.integrations](modules/integrations/treefmt)



## perSystem\.snow-blower\.just\.package



The just package to use\.



*Type:*
package



*Default:*
` pkgs.just `

*Declared by:*
 - [just, via option flake\.flakeModules\.just](modules/just)



## perSystem\.snow-blower\.just\.commonFileName



The name of the common justfile generated by this module\.



*Type:*
string



*Default:*
` "just-flake.just" `

*Declared by:*
 - [just, via option flake\.flakeModules\.just](modules/just)



## perSystem\.snow-blower\.just\.recipes



The recipes that are avaliable to just



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [just, via option flake\.flakeModules\.just](modules/just)



## perSystem\.snow-blower\.just\.recipes\.\<name>\.enable



Whether to enable this recipe\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [just/recipe-module\.nix](modules/just/recipe-module.nix)



## perSystem\.snow-blower\.just\.recipes\.\<name>\.justfile



The justfile representing this recipe\.



*Type:*
string or path

*Declared by:*
 - [just/recipe-module\.nix](modules/just/recipe-module.nix)



## perSystem\.snow-blower\.just\.recipes\.\<name>\.outputs\.justfile



The justfile code for importing this recipe’s justfile\.

See https://just\.systems/man/en/chapter_53\.html



*Type:*
string *(read only)*



*Default:*
` "" `

*Declared by:*
 - [just/recipe-module\.nix](modules/just/recipe-module.nix)



## perSystem\.snow-blower\.languages\.javascript\.enable



Whether to enable tools for JavaScript development\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.package



The Node\.js package to use\.



*Type:*
package



*Default:*
` pkgs.nodejs-slim `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.bun\.enable



Whether to enable install bun\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.bun\.package



The bun package to use\.



*Type:*
package



*Default:*
` pkgs.bun `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.bun\.install\.enable



Whether to enable bun install during snow blower initialisation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.corepack\.enable



Whether to enable wrappers for npm, pnpm and Yarn via Node\.js Corepack\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.directory



The JavaScript project’s root directory\. Defaults to the root of the devenv project\.
Can be an absolute path or one relative to the root of the snow blower project\.



*Type:*
string



*Default:*
` config.snow-blower.paths.root `



*Example:*
` "./directory" `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.npm\.enable



Whether to enable install npm\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.npm\.package



The Node\.js package to use\.



*Type:*
package



*Default:*
` pkgs.nodejs `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.npm\.install\.enable



Whether to enable npm install during snow blower initialisation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.pnpm\.enable



Whether to enable install pnpm\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.pnpm\.package



The pnpm package to use\.



*Type:*
package



*Default:*
` pkgs.nodePackages.pnpm `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.pnpm\.install\.enable



Whether to enable pnpm install during snow blower initialisation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.yarn\.enable



Whether to enable install yarn\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.yarn\.package



The yarn package to use\.



*Type:*
package



*Default:*
` pkgs.yarn `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.javascript\.yarn\.install\.enable



Whether to enable yarn install during snow blower initialisation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/javascript, via option flake\.flakeModules\.languages](modules/languages/javascript)



## perSystem\.snow-blower\.languages\.php\.enable



Whether to enable tools for PHP development\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.package



Allows you to [override the default used package](https://nixos\.org/manual/nixpkgs/stable/\#ssec-php-user-guide)
to adjust the settings or add more extensions\. You can find the
extensions using ` devenv search 'php extensions' `



*Type:*
package



*Default:*
` pkgs.php `



*Example:*

```
pkgs.php.buildEnv {
  extensions = { all, enabled }: with all; enabled ++ [ xdebug ];
  extraConfig = ''
    memory_limit=1G
  '';
};

```

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.packages



Attribute set of packages including composer



*Type:*
submodule



*Default:*
` pkgs `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.packages\.composer



composer package



*Type:*
null or package



*Default:*
` pkgs.phpPackages.composer `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.disableExtensions



PHP extensions to disable\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.extensions



PHP extensions to enable\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.ini



PHP\.ini directives\. Refer to the “List of php\.ini directives” of PHP’s



*Type:*
null or strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.languages\.php\.version



The PHP version to use\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [languages/php, via option flake\.flakeModules\.languages](modules/languages/php)



## perSystem\.snow-blower\.process-compose\.package



The process-compose package to use\.



*Type:*
package



*Default:*
` pkgs.process-compose `

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.process-compose\.settings\.after



Bash code to execute after stopping processes\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.process-compose\.settings\.before



Bash code to execute before starting processes\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.process-compose\.settings\.server



Top-level process-compose\.yaml options when that implementation is used\.



*Type:*
attribute set



*Default:*

```
{
  version = "0.5";
  unix-socket = "${config.snow-blower.paths.runtime}/pc.sock";
  tui = true;
}

```



*Example:*

```
{
  log_level = "fatal";
  log_location = "/path/to/combined/output/logfile.log";
  version = "0.5";
}
```

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.processes



Processes can be started with ` just up ` and run in foreground mode\.



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.processes\.\<name>\.exec



Bash code to run the process\.



*Type:*
string

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.processes\.\<name>\.process-compose



process-compose\.yaml specific process attributes\.

Example: https://github\.com/F1bonacc1/process-compose/blob/main/process-compose\.yaml\`

Only used when using ` process.implementation = "process-compose"; `



*Type:*
attribute set



*Default:*
` { } `



*Example:*

```
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

*Declared by:*
 - [processes, via option flake\.flakeModules\.processes](modules/processes)



## perSystem\.snow-blower\.scripts



A set of scripts available when the environment is active\.



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.scripts\.\<name>\.package



The package to use to run the script\.



*Type:*
package



*Default:*
` <derivation bash-5.2p26> `

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.scripts\.\<name>\.binary



Override the binary name if it doesn’t match package name



*Type:*
string



*Default:*
` "bash" `

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.scripts\.\<name>\.description



Description of the script\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.scripts\.\<name>\.exec



Shell code to execute when the script is run\.



*Type:*
string

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.scripts\.\<name>\.just\.enable



Include this script in just runner\.



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [scripts, via option flake\.flakeModules\.scripts](modules/scripts)



## perSystem\.snow-blower\.services\.adminer\.enable



Whether to enable Adminer  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/adminer, via option flake\.flakeModules\.services](modules/services/adminer)



## perSystem\.snow-blower\.services\.adminer\.package



The package Adminer should use\.



*Type:*
package



*Default:*
` <derivation adminer-4.8.1> `

*Declared by:*
 - [services/adminer, via option flake\.flakeModules\.services](modules/services/adminer)



## perSystem\.snow-blower\.services\.adminer\.settings\.host



The host Adminer will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/adminer, via option flake\.flakeModules\.services](modules/services/adminer)



## perSystem\.snow-blower\.services\.adminer\.settings\.port



The port Adminer will listen on



*Type:*
signed integer



*Default:*
` 8080 `

*Declared by:*
 - [services/adminer, via option flake\.flakeModules\.services](modules/services/adminer)



## perSystem\.snow-blower\.services\.blackfire\.enable



Whether to enable Blackfire  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.package



The package Blackfire should use\.



*Type:*
package



*Default:*
` <derivation blackfire-2.28.7> `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.enableApm



Whether to enable Enables application performance monitoring, requires special subscription\.
\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.client-id



Sets the client id used to authenticate with Blackfire\.
You can find your personal client-id at [https://blackfire\.io/my/settings/credentials](https://blackfire\.io/my/settings/credentials)\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.client-token



Sets the client token used to authenticate with Blackfire\.
You can find your personal client-token at [https://blackfire\.io/my/settings/credentials](https://blackfire\.io/my/settings/credentials)\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.host



The host Blackfire will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.port



The port Blackfire will listen on



*Type:*
signed integer



*Default:*
` 8307 `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.server-id



Sets the server id used to authenticate with Blackfire\.
You can find your personal server-id at [https://blackfire\.io/my/settings/credentials](https://blackfire\.io/my/settings/credentials)\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.blackfire\.settings\.server-token



Sets the server token used to authenticate with Blackfire\.
You can find your personal server-token at [https://blackfire\.io/my/settings/credentials](https://blackfire\.io/my/settings/credentials)\.



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [services/blackfire, via option flake\.flakeModules\.services](modules/services/blackfire)



## perSystem\.snow-blower\.services\.elasticsearch\.enable



Whether to enable Elasticsearch  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.package



The package Elasticsearch should use\.



*Type:*
package



*Default:*
` <derivation elasticsearch-7.17.16> `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.cluster_name

Elasticsearch name that identifies your cluster for auto-discovery\.



*Type:*
string



*Default:*
` "elasticsearch" `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.extraCmdLineOptions



Extra command line options for the elasticsearch launcher\.



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.extraConf



Extra configuration for elasticsearch\.



*Type:*
string



*Default:*
` "" `



*Example:*

```
''
  node.name: "elasticsearch"
  node.master: true
  node.data: false
''
```

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.extraJavaOptions



Extra command line options for Java\.



*Type:*
list of string



*Default:*
` [ ] `



*Example:*

```
[
  "-Djava.net.preferIPv4Stack=true"
]
```

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.host



The host Elasticsearch will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.logging



Elasticsearch logging configuration\.



*Type:*
string



*Default:*

```
''
  logger.action.name = org.elasticsearch.action
  logger.action.level = info
  appender.console.type = Console
  appender.console.name = console
  appender.console.layout.type = PatternLayout
  appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n
  rootLogger.level = info
  rootLogger.appenderRef.console.ref = console
''
```

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.plugins



Extra elasticsearch plugins



*Type:*
list of package



*Default:*
` [ ] `



*Example:*
` [ pkgs.elasticsearchPlugins.discovery-ec2 ] `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.port



The port Elasticsearch will listen on



*Type:*
signed integer



*Default:*
` 9200 `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.single_node



Start a single-node cluster



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.elasticsearch\.settings\.tcp_port



Elasticsearch port for the node to node communication\.



*Type:*
signed integer



*Default:*
` 9300 `

*Declared by:*
 - [services/elasticsearch, via option flake\.flakeModules\.services](modules/services/elasticsearch)



## perSystem\.snow-blower\.services\.memcached\.enable



Whether to enable Memcached  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)



## perSystem\.snow-blower\.services\.memcached\.package



The package Memcached should use\.



*Type:*
package



*Default:*
` <derivation memcached-1.6.27> `

*Declared by:*
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)



## perSystem\.snow-blower\.services\.memcached\.settings\.host



The host Memcached will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)



## perSystem\.snow-blower\.services\.memcached\.settings\.port



The port Memcached will listen on



*Type:*
signed integer



*Default:*
` 11211 `

*Declared by:*
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)



## perSystem\.snow-blower\.services\.memcached\.settings\.startArgs



Additional arguments passed to ` memcached ` during startup\.



*Type:*
list of strings concatenated with “\\n”



*Default:*
` [ ] `



*Example:*

```
[
  "--memory-limit=100M"
]
```

*Declared by:*
 - [services/memcached, via option flake\.flakeModules\.services](modules/services/memcached)



## perSystem\.snow-blower\.services\.mysql\.enable



Whether to enable MySQL  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.package



The package MySQL should use\.



*Type:*
package



*Default:*
` <derivation mariadb-server-10.11.8> `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.configuration



MySQL configuration\.



*Type:*
lazy attribute set of lazy attribute set of anything



*Default:*
` { } `



*Example:*

```
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

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.ensureUsers



Ensures that the specified users exist and have at least the ensured permissions\.
The MySQL users will be identified using Unix socket authentication\. This authenticates the Unix user with the
same name only, and that without the need for a password\.
This option will never delete existing users or remove permissions, especially not when the value of this
option is changed\. This means that users created and permissions assigned once through this option or
otherwise have to be removed manually\.



*Type:*
list of (submodule)



*Default:*
` [ ] `



*Example:*

```
[
  {
    name = "snow";
    ensurePermissions = {
      "snow.*" = "ALL PRIVILEGES";
    };
  }
]

```

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.ensureUsers\.\*\.ensurePermissions



Permissions to ensure for the user, specified as attribute set\.
The attribute names specify the database and tables to grant the permissions for,
separated by a dot\. You may use wildcards here\.
The attribute values specfiy the permissions to grant\.
You may specify one or multiple comma-separated SQL privileges here\.
For more information on how to specify the target
and on which privileges exist, see the
[GRANT syntax](https://mariadb\.com/kb/en/library/grant/)\.
The attributes are used as ` GRANT ${attrName} ON ${attrValue} `\.



*Type:*
attribute set of string



*Default:*
` { } `



*Example:*

```
{
  "database.*" = "ALL PRIVILEGES";
  "*.*" = "SELECT, LOCK TABLES";
}

```

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.ensureUsers\.\*\.name



Name of the user to ensure\.



*Type:*
string

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.ensureUsers\.\*\.password



Password of the user to ensure\.



*Type:*
null or string



*Default:*
` null `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.host



The host MySQL will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.importTimeZones



Whether to import tzdata on the first startup of the mysql server



*Type:*
null or boolean



*Default:*
` null `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.initialDatabases



List of database names and their initial schemas that should be used to create databases on the first startup
of MySQL\. The schema attribute is optional: If not specified, an empty database is created\.



*Type:*
list of (submodule)



*Default:*
` [ ] `



*Example:*

```
[
  { name = "foodatabase"; schema = ./foodatabase.sql; }
  { name = "bardatabase"; }
]

```

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.initialDatabases\.\*\.name



The name of the database to create\.



*Type:*
string

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.initialDatabases\.\*\.schema



The initial schema of the database; if null (the default),
an empty database is created\.



*Type:*
null or path



*Default:*
` null `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.port



The port MySQL will listen on



*Type:*
signed integer



*Default:*
` 3306 `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.mysql\.settings\.useDefaultsExtraFile



Whether to use defaults-exta-file for the mysql command instead of defaults-file\.
This is useful if you want to provide a config file on the command line\.
However this can problematic if you have MySQL installed globaly because its config might leak into your environment\.
This option does not affect the mysqld command\.



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [services/mysql, via option flake\.flakeModules\.services](modules/services/mysql)



## perSystem\.snow-blower\.services\.redis\.enable



Whether to enable Redis  service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)



## perSystem\.snow-blower\.services\.redis\.package



The package Redis should use\.



*Type:*
package



*Default:*
` <derivation redis-7.2.5> `

*Declared by:*
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)



## perSystem\.snow-blower\.services\.redis\.settings\.extraConfig



Additional text to be appended to ` redis.conf `\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "locale-collate C" `

*Declared by:*
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)



## perSystem\.snow-blower\.services\.redis\.settings\.host



The host Redis will listen on



*Type:*
string



*Default:*
` "127.0.0.1" `

*Declared by:*
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)



## perSystem\.snow-blower\.services\.redis\.settings\.port



The port Redis will listen on



*Type:*
signed integer



*Default:*
` 6379 `

*Declared by:*
 - [services/redis, via option flake\.flakeModules\.services](modules/services/redis)



## perSystem\.snow-blower\.shell\.build\.devShell



The development shell with Snow Blower and its underlying programs



*Type:*
package *(read only)*

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)



## perSystem\.snow-blower\.shell\.interactive



Bash code to execute on interactive startups



*Type:*
list of string



*Default:*
` "" `

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)



## perSystem\.snow-blower\.shell\.motd



Message Of The Day\.

This is the welcome message that is being printed when the user opens
the shell\.

You may use any valid ansi color from the 8-bit ansi color table\. For example, to use a green color you would use something like {106}\. You may also use {bold}, {italic}, {underline}\. Use {reset} to turn off all attributes\.



*Type:*
string



*Default:*

```
''
  ❄️ 💨 Snow Blower: All flake no fluff.
''
```

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)



## perSystem\.snow-blower\.shell\.startup



Bash code to execute on startup\.



*Type:*
list of string



*Default:*
` "" `

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)



## perSystem\.snow-blower\.shell\.stdenv



The stdenv to use for the developer environment\.



*Type:*
package



*Default:*
` <derivation stdenv-linux> `

*Declared by:*
 - [shell, via option flake\.flakeModules\.shell](modules/shell)


