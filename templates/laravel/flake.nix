{
  description = "A simple flake using the make-shell flake module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snow-blower.url = "github:use-the-fork/snow-blower";
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";

    accept-flake-config = true;
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://cache.garnix.io"
      "https://devenv.cachix.org"
    ];
  };

  outputs = inputs:
    inputs.snow-blower.mkSnowBlower {
      inherit inputs;
      perSystem = {
        config,
        pkgs,
        ...
      }: let
        serv = config.snow-blower.services;
        lang = config.snow-blower.languages;
        env = config.snow-blower.env;

        composer = "${lang.php.packages.composer}/bin/composer";
        php = "${lang.php.package}/bin/php";
        npm = "${lang.javascript.npm.package}/bin/npm";

        envKeys = builtins.attrNames config.snow-blower.env;
        unsetEnv = builtins.concatStringsSep "\n" (
          map (key: "unset ${key}") envKeys
        );

      in {
        snow-blower = {
          paths.src = ./.;
          dotenv.enable = true;

          env = {
            "DB_HOST" = serv.mysql.settings.host;
            "DB_PORT" = toString serv.mysql.settings.port;
            "DB_DATABASE" = "sail_laravel";
            "DB_USERNAME" = "sail";
            "DB_PASSWORD" = "sail";

            "REDIS_HOST" = serv.redis.settings.host;
            "REDIS_PORT" = toString serv.redis.settings.port;
          };

          scripts = {
            artisan.exec = ''
              ${unsetEnv}
                # Unset .env variables, so laravel reads the .env files by itself
                exec ${php} artisan $@
            '';
            a.exec = ''
              ${unsetEnv}
                exec ${php} artisan $@
            '';
            pf.exec = ''
              ${unsetEnv}
                ./vendor/bin/pest --filter "$@"
            '';
            p.exec = ''
              ${unsetEnv}
                ./vendor/bin/pest
            '';
          };

          processes = {
            artisan-serve.exec = ''
              ${unsetEnv}
                exec ${php} artisan serve
            '';

            npm-dev.exec = ''
              ${unsetEnv}
                npm run dev
            '';
          };

          languages = {
            php = {
              enable = true;
              version = "8.2";
              extensions = ["grpc" "redis" "imagick" "memcached" "xdebug"];
              ini = ''
                memory_limit = 5G
                max_execution_time = 90
              '';
            };

            javascript.enable = true;
            javascript.npm.enable = true;
          };

          services = {
            aider = {
              enable = true;
            };
            mysql = {
              enable = true;
              settings = {
                initialDatabases = [
                  {
                    name = env."DB_DATABASE";
                  }
                ];
                ensureUsers = [
                  {
                    name = env."DB_USERNAME";
                    password = env."DB_PASSWORD";
                    ensurePermissions = {
                      "*.*" = "ALL PRIVILEGES";
                    };
                  }
                ];
                configuration = {
                  mysqld = {
                    port = env."DB_PORT";
                  };
                };
              };
            };
            redis.enable = false;
          };

          integrations = {
            agenix = {
              enable = true;
              secrets = {
                ".env" = {
                  inherit publicKeys;
                };
              };
            };

            git-cliff.enable = true;

            treefmt = {
              settings.formatter = {
                "pint" = {
                  command = "${composer}";
                  options = [
                    "lint"
                  ];
                  includes = ["*.php"];
                };
                "refactor-file" = {
                  command = "${composer}";
                  options = [
                    "refactor-file"
                    "--"
                    "--debug"
                    "process"
                  ];
                  includes = ["*.php"];
                };
              };
              programs = {
                alejandra.enable = true;
                biome.enable = true;
              };
            };

            git-hooks.hooks = {
              treefmt = {
                enable = true;
              };
            };
          };
        };
      };
    };
}
