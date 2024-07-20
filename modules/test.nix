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
          just.recipes.treefmt.enable = true;

          languages = {
            php.enable = true;
          };

          scripts."devenv-generate-doc-options" = {
            just.enable = true;
            description = "Generate option docs.";
            exec = ''
              set -e
              echo "did this work?"
            '';
          };

          #          services.mysql.enable = true;

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

          services.adminer.enable = true;

          process-compose.processes = {
            artisan-serve.exec = ''
              echo "123"
            '';
          };
        };
      }
    );
  };
}
