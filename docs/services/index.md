# Services

Snow Blower provides built-in support for various services, making it easy to set up development environments with the services your project needs.

## Supported Services

Snow Blower currently supports the following services:

- [Adminer](./adminer.md) - Database management tool
- [Aider](./aider.md) - AI pair programming assistant
- [Blackfire](./blackfire.md) - Performance testing and profiling
- [Elasticsearch](./elasticsearch.md) - Search and analytics engine
- [Memcached](./memcached.md) - Distributed memory caching system
- [MySQL](./mysql.md) - Relational database management system
- [Redis](./redis.md) - In-memory data structure store
- [Supervisord](./supervisord.md) - Process control system

Each service module provides:

- Automatic installation and configuration
- Development-ready defaults
- Integration with other Snow Blower features
- Easy customization options

## Adding Services to Your Project

To add services to your project, you can enable the specific service module in your `flake.nix` file:

```nix
{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    snow-blower.url = "github:use-the-fork/snow-blower";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      inherit inputs;

      imports = [
        inputs.snow-blower.flakeModule
      ];

      src = ./.;

      perSystem = {pkgs, ...}: {
        snow-blower = {
          # Services configuration
          services = {
            mysql = {
              enable = true;
              # Service-specific configuration
              settings = {
                port = 3306;
              };
            };
            redis.enable = true;
            # Add other services as needed
          };
        };
      };
    };
}
```

Refer to the specific service documentation for detailed configuration options.
