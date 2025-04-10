# Elasticsearch (services)

Options for configuring elasticsearch in the services category.

## enable
**Location:** perSystem.snow-blower.services.elasticsearch.enable

Whether to enable Elasticsearch  service.

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

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## kibana.enable
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.enable

Whether to enable Kibana  service.

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

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.package
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.package

The package Kibana should use.

**Type:**

`package`

**Default:**
```nix
<derivation kibana-7.17.27>
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.settings.extraCmdLineOptions
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.settings.extraCmdLineOptions

Extra command line options for the elasticsearch launcher.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.settings.extraConf
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.settings.extraConf

Extra configuration for elasticsearch.

**Type:**

`string`

**Default:**
```nix
""
```

**Example:**

```nix
''
  node.name: "elasticsearch"
  node.master: true
  node.data: false
''
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.settings.host
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.settings.host

The host Kibana will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.settings.hosts
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.settings.hosts

The URLs of the Elasticsearch instances to use for all your queries.
All nodes listed here must be on the same cluster.

Defaults to <literal>[ "http://localhost:9200" ]</literal>.

This option is only valid when using kibana >= 6.6.


**Type:**

`null or (list of string)`

**Default:**
```nix
[
  "http://127.0.0.1:9200"
]
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## kibana.settings.port
**Location:** perSystem.snow-blower.services.elasticsearch.kibana.settings.port

The port Kibana will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
5601
```

**Declared by:**

- [services/elasticsearch/kibana.nix, via option flake.flakeModules.services](modules/services/elasticsearch/kibana.nix)


## package
**Location:** perSystem.snow-blower.services.elasticsearch.package

The package Elasticsearch should use.

**Type:**

`package`

**Default:**
```nix
<derivation elasticsearch-7.17.27>
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.cluster_name
**Location:** perSystem.snow-blower.services.elasticsearch.settings.cluster_name

Elasticsearch name that identifies your cluster for auto-discovery.

**Type:**

`string`

**Default:**
```nix
"elasticsearch"
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.extraCmdLineOptions
**Location:** perSystem.snow-blower.services.elasticsearch.settings.extraCmdLineOptions

Extra command line options for the elasticsearch launcher.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.extraConf
**Location:** perSystem.snow-blower.services.elasticsearch.settings.extraConf

Extra configuration for elasticsearch.

**Type:**

`string`

**Default:**
```nix
""
```

**Example:**

```nix
''
  node.name: "elasticsearch"
  node.master: true
  node.data: false
''
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.extraJavaOptions
**Location:** perSystem.snow-blower.services.elasticsearch.settings.extraJavaOptions

Extra command line options for Java.

**Type:**

`list of string`

**Default:**
```nix
[ ]
```

**Example:**

```nix
[
  "-Djava.net.preferIPv4Stack=true"
]
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.host
**Location:** perSystem.snow-blower.services.elasticsearch.settings.host

The host Elasticsearch will listen on

**Type:**

`string`

**Default:**
```nix
"127.0.0.1"
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.logging
**Location:** perSystem.snow-blower.services.elasticsearch.settings.logging

Elasticsearch logging configuration.

**Type:**

`string`

**Default:**
```nix
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

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.plugins
**Location:** perSystem.snow-blower.services.elasticsearch.settings.plugins

Extra elasticsearch plugins

**Type:**

`list of package`

**Default:**
```nix
[ ]
```

**Example:**

```nix
[ pkgs.elasticsearchPlugins.discovery-ec2 ]
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.port
**Location:** perSystem.snow-blower.services.elasticsearch.settings.port

The port Elasticsearch will listen on

**Type:**

`signed integer or string`

**Default:**
```nix
9200
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.single_node
**Location:** perSystem.snow-blower.services.elasticsearch.settings.single_node

Start a single-node cluster

**Type:**

`boolean`

**Default:**
```nix
true
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)


## settings.tcp_port
**Location:** perSystem.snow-blower.services.elasticsearch.settings.tcp_port

Elasticsearch port for the node to node communication.

**Type:**

`signed integer`

**Default:**
```nix
9300
```

**Declared by:**

- [services/elasticsearch, via option flake.flakeModules.services](modules/services/elasticsearch)

