topLevel @ {
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    ./shell
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.test = _flakeModule: {
    imports = [
      topLevel.config.flake.flakeModules.shell
    ];
    options.perSystem = flake-parts-lib.mkPerSystemOption (
      _: {
        snow-blower = {
          languages = {
            php.enable = true;
          };

          ai.laravel.enable = true;
          ai.nix.enable = true;

          scripts = {
            "reload" = {
              just.enable = true;
              description = "reloads snow blower.";
              exec = ''
                direnv reload
              '';
            };
          };

          integrations = {
            agenix = {
              enable = true;
              secrets = {
                foo = {
                  file = ./secrets/foo.age;
                  publicKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH"];
                };
              };
            };

            git-cliff.enable = true;

            treefmt = {
              programs = {
                alejandra.enable = true;
                deadnix.enable = true;
                statix = {
                  enable = true;
                  disabled-lints = [
                    "manual_inherit_from"
                  ];
                };
              };
            };

            git-hooks.hooks = {
              treefmt = {
                enable = true;
              };
            };
          };

          services.adminer.enable = true;

          processes = {
            artisan-serve.exec = ''
              echo "123"
            '';
          };
        };
      }
    );
  };
}
