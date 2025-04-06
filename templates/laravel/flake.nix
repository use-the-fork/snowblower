{
  description = "Laravel PHP application development environment with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snow-blower.url = "github:use-the-fork/snow-blower";
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

#        If Needed add your public keys here.
#        publicKeys = [
#          ""
#        ];

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
                php artisan $@
            '';
            a.exec = ''
              ${unsetEnv}
                php artisan $@
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
                php artisan serve
            '';

            npm-dev.exec = ''
              ${unsetEnv}
                npm run dev
            '';
          };

          languages = {
            php = {
              enable = true;
              package = pkgs.php82;
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
              settings = {
                extraConf = {
                  read = ["CONVENTIONS-BACKEND.MD"];
                  lint-cmd = ["composer lint"];
                  test-cmd = "./vendor/bin/pest";
                };
              };
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
              enable = false;
#              Uncomment this after adding your publicKeys
#              secrets = {
#                ".env" = {
#                  inherit publicKeys;
#                };
#              };
            };

            git-cliff.enable = true;

            treefmt = {
              settings.formatter = {
                "pint" = {
                  command = "composer";
                  options = [
                    "lint"
                  ];
                  includes = ["*.php"];
                };
                "refactor-file" = {
                  command = "composer";
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

  nixConfig = {
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "snow-blower.cachix.org-1:f14pyJhxRZJHAymrilTUpC5m+Qy6hX437tmkR22rYOk="
    ];

    extra-substituters = [
      "https://cache.nixos.org"
      "https://snow-blower.cachix.org"
    ];
  };
}
