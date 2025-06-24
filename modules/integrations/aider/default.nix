{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    pkgs,
    config,
    lib,
    ...
  }: let
    inherit (lib) types mkOption optionalString;
    inherit (lib) mkIntegration;

    commandModule = {
      imports = [./command-module.nix];
      config._module.args = {inherit pkgs;};
    };

    commandType = types.submodule commandModule;

    cfg = config.snowblower.integration.aider;
    execCommand = config.snowblower.command."ai".command;

    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [
      {
        options.snowblower.integration.aider.commands = mkOption {
          type = types.submoduleWith {
            modules = [{freeformType = types.attrsOf commandType;}];
            specialArgs = {inherit pkgs;};
          };
          default = {};
          description = ''
            The aider start commands that are added to SnowBlower.
          '';
        };
      }
    ];

    options.snowblower.integration.aider = mkIntegration {
      name = "Aider";
      package = pkgs.aider-chat;
      config = {
        "auto-commits" = false;
        "dirty-commits" = true;
        "auto-lint" = true;
        "dark-mode" = true;
        "light-mode" = false;
        "cache-prompts" = false;
        "code-theme" = "solarized-dark";
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        command."ai" = let
          subCommands = lib.mkMerge (lib.mapAttrsToList (
              name: cmdCfg: {
                "${name}" = {
                  inherit (cmdCfg) description;
                  command = "aider";
                  args =
                    lib.filter (s: s != "") [
                      "--no-show-release-notes"
                      "--model"
                      cmdCfg.model
                      (
                        if cmdCfg.watchFiles
                        then "--watch-files"
                        else "--no-watch-files"
                      )
                      (
                        if cmdCfg.suggestShellCommands
                        then "--suggest-shell-commands"
                        else "--no-suggest-shell-commands"
                      )
                      (
                        if cmdCfg.detectUrls
                        then "--detect-urls"
                        else "--no-detect-urls"
                      )
                      (
                        if cmdCfg.gitCommitVerify
                        then "--git-commit-verify"
                        else "--no-git-commit-verify"
                      )
                      (
                        optionalString cmdCfg.subtreeOnly
                        "--subtree-only"
                      )
                    ]
                    ++ (
                      if cmdCfg.separateHistoryFiles
                      then [
                        "--input-history-file"
                        "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.input.history"
                        "--chat-history-file"
                        "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.chat.history"
                        "--llm-history-file"
                        "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.llm.history"
                      ]
                      else []
                    )
                    ++ (lib.concatMap (cmd: ["--read" cmd]) cmdCfg.readFiles)
                    ++ (lib.concatMap (cmd: ["--lint-cmd" cmd]) cmdCfg.lintCommands)
                    ++ (lib.concatMap (cmd: ["--test-cmd" cmd]) cmdCfg.testCommands);
                };
              }
            )
            cfg.commands);
        in {
          displayName = "Aider";
          description = "Aider Code Assitant";
          command = "aider";
          subcommand = subCommands;
        };

        packages = [
          cfg.package
        ];

        directories = [
          "\${SB_PROJECT_STATE}/aider"
          "\${SB_PROJECT_STATE}/aider/cache"
        ];

        touchFiles = lib.flatten (lib.mapAttrsToList (
            name: cmdCfg:
              if cmdCfg.separateHistoryFiles
              then [
                "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.input.history"
                "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.chat.history"
                "\${SB_PROJECT_STATE}/aider/cache/.aider.${name}.llm.history"
              ]
              else []
          )
          cfg.commands);

        file.".aider.conf.yml" = {
          enable = true;
          source = yamlFormat.generate ".aider.conf.yml" cfg.settings.config;
        };
      };
    };
  });
}
