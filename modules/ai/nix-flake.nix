{
  inputs,
  flake-parts-lib,
  self,
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
      inherit (lib) types mkOption mkEnableOption mkIf;
      inherit (import ./utils.nix {inherit lib pkgs;}) mkAi mkAiScript;

      cfg = config.snow-blower.ai.nix;

      ai-nix = mkAiScript {
          name = "nix";
          system_message = ''${cfg.prompt.message}
                               # Examples
                               ${cfg.prompt.examples}'';
          model = cfg.settings.model;
          temperature = cfg.settings.temperature;
          maxTokens = cfg.settings.maxTokens;
      };

    in {
      options.snow-blower.ai.nix = mkAi {
        name = "NIX";
        message = ''You are a helpful assistant trained to generate Nix commands based on the users request.
        Only respond with the nix command, NOTHING ELSE, DO NOT wrap it in quotes or backticks.'';
        examples = ''user: show the outputs provided by my flake
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
         response: nix-store --verify --check-contents --repair'';
      };

      config.snow-blower = mkIf cfg.enable {
        packages = [ai-nix];
        just.recipes.ai-nix = {
          enable = true;
          justfile = lib.mkDefault ''
            #generates a `nix` command.
            @ai-nix:
              ${lib.getExe ai-nix}
          '';
        };
      };
    });
  };
}
