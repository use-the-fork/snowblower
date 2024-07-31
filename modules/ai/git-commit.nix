{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.ai = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) mkIf;
      inherit (import ./utils.nix {inherit lib pkgs;}) mkAi mkAiScript;

      cfg = config.snow-blower.ai.git-commit;

      ai-laravel = mkAiScript {
        name = "GIT - Commit";
        system_message = ''          ${cfg.prompt.message}
                                         # Examples
                                         ${cfg.prompt.examples}'';
        model = cfg.settings.model;
        temperature = cfg.settings.temperature;
        maxTokens = cfg.settings.maxTokens;
      };
    in {
      options.snow-blower.ai.laravel = mkAi {
        name = "Laravel";
        message = ''          You are a helpful assistant trained to generate Laravel commands based on the users request.
                  Only respond with the laravel command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.'';
        examples = ''          user: a command that sends emails.
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
                   response: php artisan queue:work'';
      };

      config.snow-blower = mkIf cfg.enable {
        packages = [ai-laravel];
        just.recipes.ai-laravel = {
          enable = true;
          justfile = lib.mkDefault ''
            #generates a `artisan` command.
            @ai-artisan:
              ${lib.getExe ai-laravel}
          '';
        };
      };
    });
  };
}
