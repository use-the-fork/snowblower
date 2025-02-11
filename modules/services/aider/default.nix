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
      inherit (lib) types mkOption optionalString;
      inherit (import ../utils.nix {inherit lib;}) mkService;

      cfg = config.snow-blower.services.aider;

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

          git = {
            autoCommits = mkOption {
              description = "Enable/disable auto commit of LLM changes.";
              default = true;
              type = types.bool;
            };

            dirtyCommits = mkOption {
              description = "Enable/disable commits when repo is found dirty";
              default = true;
              type = types.bool;
            };
          };

          darkMode = mkOption {
            description = "Use colors suitable for a dark terminal background.";
            default = true;
            type = types.bool;
          };

          codeTheme = mkOption {
            description = "Set the markdown code theme";
            default = "default";
            type = types.enum ["default" "monokai" "solarized-dark" "solarized-light"];
          };

          editFormat = mkOption {
            description = "Set the markdown code theme";
            default = "whole";
            type = types.enum ["whole" "diff" "diff-fenced" "udiff"];
          };

          extraConventions = mkOption {
            description = "Extra conventions for aider.";
            default = "";
            type = types.str;
            example = ''
              See settings here: https://aider.chat/docs/usage/conventions.html#specifying-coding-conventions
            '';
          };

          extraConf = mkOption {
            description = "Extra configuration for aider.";
            default = "";
            type = types.str;
            example = ''
              See settings here: https://aider.chat/docs/config/aider_conf.html
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
              aiderConventionsCommand = pkgs.writeScriptBin "snow-blower-create-aider-conventions" ''
                #!/bin/bash

                {
                  echo "## System Information"

                  ${lib.optionalString config.snow-blower.languages.php.enable ''
                  echo "* PHP Version: $(php -v | head -n 1 | awk '{print $2}')"
                ''}

                  # Add Composer direct dependencies formatted as sub-bullets under "Composer:"
                  ${lib.optionalString (config.snow-blower.languages.php.packages.composer != null) ''
                  echo "* Installed Composer Packages:"
                  composer show --direct --format=json | ${lib.getExe pkgs.jq} -r '.installed[] | "  - \(.name)@\(.version)"' | while read -r line; do
                    echo "  $line"
                  done
                ''}

                  ${lib.optionalString (config.snow-blower.languages.javascript.npm != null) ''
                  echo "* NPM Version: $(npm --version)"
                  echo "* Installed NPM Packages:"
                  npm list --depth=0 --json | ${lib.getExe pkgs.jq} -r '.dependencies | to_entries[] | "  - \(.key)@\(.value.version)"' | while read -r line; do
                    echo "  $line"
                  done
                ''}

                  # Append additional configuration
                  echo "${cfg.settings.extraConventions}"
                } > .aider.CONVENTIONS.md
              '';

              aiderConfig = ''
                model: ${cfg.settings.model}
                ${lib.optionalString cfg.settings.darkMode "dark-mode: true"}
                dirty-commits: ${
                  if cfg.settings.git.dirtyCommits
                  then "true"
                  else "false"
                }
                auto-commits: ${
                  if cfg.settings.git.autoCommits
                  then "true"
                  else "false"
                }
                code-theme: ${cfg.settings.codeTheme}
                edit-format: ${cfg.settings.editFormat}
                read: [.aider.CONVENTIONS.md]
                lint-cmd: treefmt
                check-update: false
                ${cfg.settings.extraConf}
              '';

              aiderYml = pkgs.writeTextFile {
                name = ".aider.conf.yml";
                text = aiderConfig;
              };
            in [
              ''
                source ${lib.getExe aiderConventionsCommand}
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
