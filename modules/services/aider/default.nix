{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.services = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      pkgs,
      config,
      lib,
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.aider;

      yamlFormat = pkgs.formats.yaml {};

      playwright = let
        pred = drv: drv.pname == "playwright";
        drv = lib.findSingle pred "none" "multiple" pkgs.aider-chat.optional-dependencies.playwright;
      in
        assert drv != "none" && drv != "multiple"; drv;
    in {
      options.snow-blower.services.aider = mkService {
        name = "Aider";
        package = pkgs.aider-chat.withPlaywright.overrideAttrs (oldAttrs: {
          makeWrapperArgs =
            (oldAttrs.makeWrapperArgs or [])
            ++ [
              # Ref: https://nixos.wiki/wiki/Playwright
              # Related: https://github.com/Aider-AI/aider/issues/2192
              ''--set PLAYWRIGHT_BROWSERS_PATH "${playwright.driver.browsers}"''
              "--set PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS true"
            ];
        });
        extraOptions = {
          model = mkOption {
            description = "Specify the model to use for the main chat.";
            default = "gpt-4o";
            type = types.str;
          };

          auto-commits = mkOption {
            description = "Enable/disable auto commit of LLM changes.";
            default = false;
            type = types.bool;
          };

          dirty-commits = mkOption {
            description = "Enable/disable commits when repo is found dirty";
            default = true;
            type = types.bool;
          };

          auto-lint = mkOption {
            description = "Enable/disable automatic linting after changes";
            default = true;
            type = types.bool;
          };

          dark-mode = mkOption {
            description = "Use colors suitable for a dark terminal background.";
            default = true;
            type = types.bool;
          };

          light-mode = mkOption {
            description = "Use colors suitable for a light terminal background";
            default = false;
            type = types.bool;
          };

          cache-prompts = mkOption {
            description = "Enable caching of prompts.";
            default = false;
            type = types.bool;
          };

          code-theme = mkOption {
            description = "Set the markdown code theme";
            default = "default";
            type = types.enum ["default" "monokai" "solarized-dark" "solarized-light"];
          };

          edit-format = mkOption {
            description = "Set the markdown code theme";
            default = "diff";
            type = types.enum ["whole" "diff" "diff-fenced" "udiff"];
          };

          extraConf = mkOption {
            type = types.submodule {freeformType = yamlFormat.type;};
            default = {};
            description = ''
              Extra configuration for aider, see
              <link xlink:href="See settings here: https://aider.chat/docs/config/aider_conf.html"/>
              for supported values.
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snow-blower = {
          packages = [
            cfg.package
          ];

          shell = {
            startup = let
              cfgWithoutExcludedKeys = lib.attrsets.filterAttrs (name: _value: name != "conventions" && name != "extraConf" && name != "port" && name != "host") cfg.settings;
              cfgWithExtraConf = lib.attrsets.recursiveUpdate cfgWithoutExcludedKeys (cfg.settings.extraConf
                // {
                  lint-cmd = "${lib.getExe config.snow-blower.integrations.treefmt.build.wrapper}";
                  check-update = false;
                });

              aiderYml = yamlFormat.generate "aider-conf" cfgWithExtraConf;
            in [
              ''
                ln -sf ${builtins.toString aiderYml} ./.aider.conf.yml
              ''
            ];
          };

          just.recipes.ai = {
            enable = true;
            justfile = lib.mkDefault ''
              #Starts aider
              @ai:
                ${lib.getExe cfg.package}
            '';
          };
        };
      };
    });
  };
}
