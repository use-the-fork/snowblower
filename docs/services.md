## perSystem

A function from system to flake-like attributes omitting the `<system>`
attribute.

Modules defined here have access to the suboptions and [some convenient
module arguments](../module-arguments.html).

*Type:* module

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)
- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)
- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)
- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)
- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)
- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)
- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)
- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)
- [services/adminer, via option
  flake.flakeModules.services](modules/services/adminer)

## perSystem.snow-blower.services.adminer.enable

Whether to enable Adminer service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/adminer, via option
  flake.flakeModules.services](modules/services/adminer)

## perSystem.snow-blower.services.adminer.package

The package Adminer should use.

*Type:* package

*Default:* `<derivation adminer-5.1.0>`

*Declared by:*

- [services/adminer, via option
  flake.flakeModules.services](modules/services/adminer)

## perSystem.snow-blower.services.adminer.settings.host

The host Adminer will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/adminer, via option
  flake.flakeModules.services](modules/services/adminer)

## perSystem.snow-blower.services.adminer.settings.port

The port Adminer will listen on

*Type:* signed integer or string

*Default:* `8080`

*Declared by:*

- [services/adminer, via option
  flake.flakeModules.services](modules/services/adminer)

## perSystem.snow-blower.services.aider.enable

Whether to enable Aider service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.package

The package Aider should use.

*Type:* package

*Default:* `<derivation aider-chat-0.81.0>`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.auto-commits

Enable/disable auto commit of LLM changes.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.auto-lint

Enable/disable automatic linting after changes

*Type:* boolean

*Default:* `true`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.cache-prompts

Enable caching of prompts.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.code-theme

Set the markdown code theme

*Type:* one of “default”, “monokai”, “solarized-dark”, “solarized-light”

*Default:* `"default"`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.dark-mode

Use colors suitable for a dark terminal background.

*Type:* boolean

*Default:* `true`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.dirty-commits

Enable/disable commits when repo is found dirty

*Type:* boolean

*Default:* `true`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.edit-format

Set the markdown code theme

*Type:* one of “whole”, “diff”, “diff-fenced”, “udiff”

*Default:* `"diff"`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.extraConf

Extra configuration for aider, see \<link xlink:href=“See settings here:
https://aider.chat/docs/config/aider_conf.html”/\> for supported values.

*Type:* YAML value

*Default:* `{ }`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.host

The host Aider will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.light-mode

Use colors suitable for a light terminal background

*Type:* boolean

*Default:* `false`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.model

Specify the model to use for the main chat.

*Type:* string

*Default:* `"sonnet"`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.aider.settings.port

The port Aider will listen on

*Type:* signed integer or string

*Default:* `0`

*Declared by:*

- [services/aider, via option
  flake.flakeModules.services](modules/services/aider)

## perSystem.snow-blower.services.blackfire.enable

Whether to enable Blackfire service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.package

The package Blackfire should use.

*Type:* package

*Default:* `<derivation blackfire-2.28.23>`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.enableApm

Whether to enable Enables application performance monitoring, requires
special subscription. .

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.client-id

Sets the client id used to authenticate with Blackfire. You can find
your personal client-id at
<https://blackfire.io/my/settings/credentials>.

*Type:* string

*Default:* `""`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.client-token

Sets the client token used to authenticate with Blackfire. You can find
your personal client-token at
<https://blackfire.io/my/settings/credentials>.

*Type:* string

*Default:* `""`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.host

The host Blackfire will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.port

The port Blackfire will listen on

*Type:* signed integer or string

*Default:* `8307`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.server-id

Sets the server id used to authenticate with Blackfire. You can find
your personal server-id at
<https://blackfire.io/my/settings/credentials>.

*Type:* string

*Default:* `""`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.blackfire.settings.server-token

Sets the server token used to authenticate with Blackfire. You can find
your personal server-token at
<https://blackfire.io/my/settings/credentials>.

*Type:* string

*Default:* `""`

*Declared by:*

- [services/blackfire, via option
  flake.flakeModules.services](modules/services/blackfire)

## perSystem.snow-blower.services.elasticsearch.enable

Whether to enable Elasticsearch service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.package

The package Elasticsearch should use.

*Type:* package

*Default:* `<derivation elasticsearch-7.17.27>`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.kibana.enable

Whether to enable Kibana service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.package

The package Kibana should use.

*Type:* package

*Default:* `<derivation kibana-7.17.27>`

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.settings.extraCmdLineOptions

Extra command line options for the elasticsearch launcher.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.settings.extraConf

Extra configuration for elasticsearch.

*Type:* string

*Default:* `""`

*Example:*

    ''
      node.name: "elasticsearch"
      node.master: true
      node.data: false
    ''

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.settings.host

The host Kibana will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.settings.hosts

The URLs of the Elasticsearch instances to use for all your queries. All
nodes listed here must be on the same cluster.

Defaults to \<literal\>\[ “http://localhost:9200” \]\</literal\>.

This option is only valid when using kibana \>= 6.6.

*Type:* null or (list of string)

*Default:*

    [
      "http://127.0.0.1:9200"
    ]

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.kibana.settings.port

The port Kibana will listen on

*Type:* signed integer or string

*Default:* `5601`

*Declared by:*

- [services/elasticsearch/kibana.nix, via option
  flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)

## perSystem.snow-blower.services.elasticsearch.settings.cluster_name

Elasticsearch name that identifies your cluster for auto-discovery.

*Type:* string

*Default:* `"elasticsearch"`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.extraCmdLineOptions

Extra command line options for the elasticsearch launcher.

*Type:* list of string

*Default:* `[ ]`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.extraConf

Extra configuration for elasticsearch.

*Type:* string

*Default:* `""`

*Example:*

    ''
      node.name: "elasticsearch"
      node.master: true
      node.data: false
    ''

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.extraJavaOptions

Extra command line options for Java.

*Type:* list of string

*Default:* `[ ]`

*Example:*

    [
      "-Djava.net.preferIPv4Stack=true"
    ]

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.host

The host Elasticsearch will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.logging

Elasticsearch logging configuration.

*Type:* string

*Default:*

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

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.plugins

Extra elasticsearch plugins

*Type:* list of package

*Default:* `[ ]`

*Example:* `[ pkgs.elasticsearchPlugins.discovery-ec2 ]`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.port

The port Elasticsearch will listen on

*Type:* signed integer or string

*Default:* `9200`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.single_node

Start a single-node cluster

*Type:* boolean

*Default:* `true`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.elasticsearch.settings.tcp_port

Elasticsearch port for the node to node communication.

*Type:* signed integer

*Default:* `9300`

*Declared by:*

- [services/elasticsearch, via option
  flake.flakeModules.services](modules/services/elasticsearch)

## perSystem.snow-blower.services.memcached.enable

Whether to enable Memcached service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)

## perSystem.snow-blower.services.memcached.package

The package Memcached should use.

*Type:* package

*Default:* `<derivation memcached-1.6.35>`

*Declared by:*

- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)

## perSystem.snow-blower.services.memcached.settings.host

The host Memcached will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)

## perSystem.snow-blower.services.memcached.settings.port

The port Memcached will listen on

*Type:* signed integer or string

*Default:* `11211`

*Declared by:*

- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)

## perSystem.snow-blower.services.memcached.settings.startArgs

Additional arguments passed to `memcached` during startup.

*Type:* list of strings concatenated with “\n”

*Default:* `[ ]`

*Example:*

    [
      "--memory-limit=100M"
    ]

*Declared by:*

- [services/memcached, via option
  flake.flakeModules.services](modules/services/memcached)

## perSystem.snow-blower.services.mysql.enable

Whether to enable MySQL service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.package

The package MySQL should use.

*Type:* package

*Default:* `<derivation mariadb-server-10.11.11>`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.configuration

MySQL configuration.

*Type:* lazy attribute set of lazy attribute set of anything

*Default:* `{ }`

*Example:*

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

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.ensureUsers

Ensures that the specified users exist and have at least the ensured
permissions. The MySQL users will be identified using Unix socket
authentication. This authenticates the Unix user with the same name
only, and that without the need for a password. This option will never
delete existing users or remove permissions, especially not when the
value of this option is changed. This means that users created and
permissions assigned once through this option or otherwise have to be
removed manually.

*Type:* list of (submodule)

*Default:* `[ ]`

*Example:*

    [
      {
        name = "snow";
        ensurePermissions = {
          "snow.*" = "ALL PRIVILEGES";
        };
      }
    ]

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.ensureUsers.\*.ensurePermissions

Permissions to ensure for the user, specified as attribute set. The
attribute names specify the database and tables to grant the permissions
for, separated by a dot. You may use wildcards here. The attribute
values specfiy the permissions to grant. You may specify one or multiple
comma-separated SQL privileges here. For more information on how to
specify the target and on which privileges exist, see the [GRANT
syntax](https://mariadb.com/kb/en/library/grant/). The attributes are
used as `GRANT ${attrName} ON ${attrValue}`.

*Type:* attribute set of string

*Default:* `{ }`

*Example:*

    {
      "database.*" = "ALL PRIVILEGES";
      "*.*" = "SELECT, LOCK TABLES";
    }

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.ensureUsers.\*.name

Name of the user to ensure.

*Type:* string

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.ensureUsers.\*.password

Password of the user to ensure.

*Type:* null or string

*Default:* `null`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.host

The host MySQL will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.importTimeZones

Whether to import tzdata on the first startup of the mysql server

*Type:* null or boolean

*Default:* `null`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.initialDatabases

List of database names and their initial schemas that should be used to
create databases on the first startup of MySQL. The schema attribute is
optional: If not specified, an empty database is created.

*Type:* list of (submodule)

*Default:* `[ ]`

*Example:*

    [
      { name = "foodatabase"; schema = ./foodatabase.sql; }
      { name = "bardatabase"; }
    ]

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.initialDatabases.\*.name

The name of the database to create.

*Type:* string

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.initialDatabases.\*.schema

The initial schema of the database; if null (the default), an empty
database is created.

*Type:* null or absolute path

*Default:* `null`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.port

The port MySQL will listen on

*Type:* signed integer or string

*Default:* `3306`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.mysql.settings.useDefaultsExtraFile

Whether to use defaults-exta-file for the mysql command instead of
defaults-file. This is useful if you want to provide a config file on
the command line. However this can problematic if you have MySQL
installed globaly because its config might leak into your environment.
This option does not affect the mysqld command.

*Type:* boolean

*Default:* `false`

*Declared by:*

- [services/mysql, via option
  flake.flakeModules.services](modules/services/mysql)

## perSystem.snow-blower.services.redis.enable

Whether to enable Redis service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)

## perSystem.snow-blower.services.redis.package

The package Redis should use.

*Type:* package

*Default:* `<derivation redis-7.2.7>`

*Declared by:*

- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)

## perSystem.snow-blower.services.redis.settings.extraConfig

Additional text to be appended to `redis.conf`.

*Type:* strings concatenated with “\n”

*Default:* `"locale-collate C"`

*Declared by:*

- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)

## perSystem.snow-blower.services.redis.settings.host

The host Redis will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)

## perSystem.snow-blower.services.redis.settings.port

The port Redis will listen on

*Type:* signed integer or string

*Default:* `6379`

*Declared by:*

- [services/redis, via option
  flake.flakeModules.services](modules/services/redis)

## perSystem.snow-blower.services.supervisord.enable

Whether to enable Supervisor service.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.package

The package Supervisor should use.

*Type:* package

*Default:* `<derivation python3.12-supervisor-4.2.5>`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.programs

Configuration for each program.

*Type:* attribute set of (submodule)

*Default:* `{ }`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.programs.\<name\>.enable

Whether to enable Enable this program.

*Type:* boolean

*Default:* `false`

*Example:* `true`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.programs.\<name\>.program

The program configuration. See
http://supervisord.org/configuration.html#program-x-section-settings

*Type:* strings concatenated with “\n”

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.settings.host

The host Supervisor will listen on

*Type:* string

*Default:* `"127.0.0.1"`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)

## perSystem.snow-blower.services.supervisord.settings.port

The port Supervisor will listen on

*Type:* signed integer or string

*Default:* `0`

*Declared by:*

- [services/supervisord, via option
  flake.flakeModules.services](modules/services/supervisord)
