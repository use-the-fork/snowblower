{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    pkgs,
    config,
    lib,
    ...
  }: let
    inherit (lib) types mkOption mkDefault;
    inherit (lib) mkIntegration;

    commandModule = {
      imports = [./command-module.nix];
      config._module.args = {inherit pkgs;};
    };

    commandType = types.submodule commandModule;

    cfg = config.snowblower.integrations.aider;

    yamlFormat = pkgs.formats.yaml {};
  in {
    imports = [
      {
        options.snowblower.integrations.aider.commands = mkOption {
          type = types.submoduleWith {
            modules = [{freeformType = types.attrsOf commandType;}];
            specialArgs = {inherit pkgs;};
          };
          default = {};
          description = ''
            The aider start commands that we can run with just.
          '';
        };
      }
    ];

    options.snowblower.integrations.aider = mkIntegration {
      name = "Aider";
      package = pkgs.aider-chat;
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        integrations.aider.settings = mkDefault {
          "auto-commits" = false;
          "dirty-commits" = true;
          "auto-lint" = true;
          "dark-mode" = true;
          "light-mode" = false;
          "cache-prompts" = false;
          "code-theme" = "solarized-dark";
        };

        # shell = {
        #   startup = let
        #     cfgWithoutExcludedKeys = lib.attrsets.filterAttrs (name: _value: name != "conventions" && name != "extraConf" && name != "port" && name != "host") cfg.settings;
        #     cfgWithExtraConf = lib.attrsets.recursiveUpdate cfgWithoutExcludedKeys (cfg.settings.extraConf
        #       // {
        #         check-update = false;
        #       });

        #     aiderYml = yamlFormat.generate "aider-conf" cfgWithExtraConf;
        #   in [
        #     ''
        #       ln -sf ${builtins.toString aiderYml} ./.aider.conf.yml
        #     ''
        #   ];
        # };

        # just.recipes = lib.mkMerge (lib.mapAttrsToList (
        #     name: cmdCfg: {
        #       "ai-${name}" = {
        #         enable = true;
        #         justfile = ''
        #           # ${cmdCfg.description}
        #           @ai-${name}:
        #             ${lib.getExe cfg.package} ${lib.concatStringsSep " " (lib.filter (s: s != "") [
        #             "--model ${cmdCfg.model}"
        #             (
        #               if cmdCfg.watchFiles
        #               then "--watch-files"
        #               else "--no-watch-files"
        #             )
        #             (
        #               if cmdCfg.suggestShellCommands
        #               then "--suggest-shell-commands"
        #               else "--no-suggest-shell-commands"
        #             )
        #             (
        #               if cmdCfg.detectUrls
        #               then "--detect-urls"
        #               else "--no-detect-urls"
        #             )
        #             (
        #               if cmdCfg.gitCommitVerify
        #               then "--git-commit-verify"
        #               else "--no-git-commit-verify"
        #             )
        #             (lib.concatMapStringsSep " " (cmd: "--read \"${cmd}\"") cmdCfg.readFiles)
        #             (lib.concatMapStringsSep " " (cmd: "--lint-cmd \"${cmd}\"") cmdCfg.lintCommands)
        #             (lib.concatMapStringsSep " " (cmd: "--test-cmd \"${cmd}\"") cmdCfg.testCommands)
        #             cmdCfg.extraArgs
        #           ])}
        #         '';
        #       };
        #     }
        #   )
        #   cfg.commands);

        dependencies.shell = [
          cfg.package
        ];

        file.".aider.conf.yml" = {
          enable = true;
          source = yamlFormat.generate ".aider.conf.yml" cfg.settings;
        };
      };
    };
  });
}
