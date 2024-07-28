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

      cfg = config.snow-blower.ai.npm;

      ai-npm = mkAiScript {
        name = "npm";
        system_message = ''          ${cfg.prompt.message}
                                         # Examples
                                         ${cfg.prompt.examples}'';
        model = cfg.settings.model;
        temperature = cfg.settings.temperature;
        maxTokens = cfg.settings.maxTokens;
      };
    in {
      options.snow-blower.ai.npm = mkAi {
        name = "NPM";
        message = ''          You are a helpful assistant trained to generate npm commands based on the users request.
                            Only respond with the laravelnpm command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.'';
        examples = ''          user: install dependencies.
                            response: npm install

                             user: uninstall laravel-mix
                             response: npm uninstall laravel-mix

                             user: list available scripts to run
                             response: npm run

                             user: update vite
                             response: npm update vite

                             user: clean the npm cache
                             response: npm cache clean --force'';
      };

      config.snow-blower = mkIf cfg.enable {
        packages = [ai-npm];
        just.recipes.ai-npm = {
          enable = true;
          justfile = lib.mkDefault ''
            #generates a `npm` command.
            @ai-npm:
              ${lib.getExe ai-npm}
          '';
        };
      };
    });
  };
}
