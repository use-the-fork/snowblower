{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkIntegration;

    yamlFormat = pkgs.formats.yaml {};
    cfg = config.snowblower.integration.preCommit;
    # execCommand = config.snowblower.command."pre-commit".command;
  in {
    options.snowblower.integration.preCommit = mkIntegration {
      name = "pre-commit Hooks";
      package = pkgs.pre-commit;
      config = {
        "exclude" = "(flake.lock|.svg$|.age$|.sh$)";
      };
    };

    #   "always_run": false,
    #   "pass_filenames": true,
    #   "verbose": false

    config = lib.mkIf cfg.enable {
      snowblower = {
        command."pre-commit" = {
          displayName = "Pre-commit";
          description = "pre-commit hooks manager";
          command = "pre-commit";
          subcommand = {
            "all" = {
              description = "Run precommit on all files";
              command = "pre-commit";
              args = ["run" "--all-files"];
            };
          };
        };

        packages.tools = [
          cfg.package
        ];

        file.".pre-commit-config.yaml" = let
          # Function to convert file patterns to regex pattern
          patternsToRegex = patterns:
            if patterns == []
            then null
            else let
              # Convert glob patterns to regex
              globToRegex = pattern:
                lib.replaceStrings ["*" "." "?"] [".*" "\\." "."] pattern;
              regexPatterns = map globToRegex patterns;
            in
              "(" + (lib.concatStringsSep "|" regexPatterns) + ")";

          formatters =
            lib.mapAttrsToList
            (
              name: tool:
                lib.optionalAttrs (tool.enable && (tool.settings.format.enable or false) && (tool.settings.format.hook.enable or false)) (
                  lib.recursiveUpdate {
                    "args" = (tool.settings.format.args or []) ++ (tool.settings.format.hook.args or []);
                    "entry" = tool.settings.format.exec;
                    "id" = "${lib.toLower name}-format";
                    "language" = "system";
                    "name" = "${lib.toLower name}-format";
                    "stages" = ["pre-commit"];
                    "types" = ["file"];
                    "types_or" = [];
                  } (lib.filterAttrs (_: v: v != null) {
                      "files" = patternsToRegex (tool.settings.includes or []);
                      "exclude" = patternsToRegex (tool.settings.excludes or []);
                    }
                    // (tool.settings.format.hook.config or {}))
                )
            )
            config.snowblower.tool;

          linters =
            lib.mapAttrsToList
            (
              name: tool:
                lib.optionalAttrs (tool.enable && (tool.settings.lint.enable or false) && (tool.settings.lint.hook.enable or false)) (
                  lib.recursiveUpdate {
                    "args" = (tool.settings.lint.args or []) ++ (tool.settings.lint.hook.args or []);
                    "entry" = tool.settings.lint.exec;
                    "id" = "${lib.toLower name}-lint";
                    "language" = "system";
                    "name" = "${lib.toLower name}-lint";
                    "stages" = ["pre-commit"];
                    "types" = ["file"];
                    "types_or" = [];
                  } (lib.filterAttrs (_: v: v != null) {
                      "files" = patternsToRegex (tool.settings.includes or []);
                      "exclude" = patternsToRegex (tool.settings.excludes or []);
                    }
                    // (tool.settings.lint.hook.config or {}))
                )
            )
            config.snowblower.tool;

          finalConfiguration = let
            # Start with user's base config
            baseConfig = cfg.settings.config;

            # Filter out empty hooks
            generatedHooks = lib.filter (hook: hook != {}) (formatters ++ linters);

            # Get existing repos from user config, or empty list
            existingRepos = baseConfig.repos or [];

            # Only add local repo if we have generated hooks
            allRepos =
              if generatedHooks != []
              then
                existingRepos
                ++ [
                  {
                    repo = "local";
                    hooks = generatedHooks;
                  }
                ]
              else existingRepos;
          in
            baseConfig
            // {
              repos = allRepos;
            };
        in {
          enable = true;
          source = yamlFormat.generate ".pre-commit-config.yaml" finalConfiguration;
        };

        #change cache directory to SB state based dir
        environmentVariables = {
          PRE_COMMIT_HOME = "\${SB_PROJECT_STATE}/pre_commit";
        };

        directories = [
          "\${SB_PROJECT_STATE}/pre_commit"
        ];

        # When we do a switch we need to make sure that pre-commit is installed if its not.
        hook.switch.activation."pre-commit" = ''pre-commit uninstall && pre-commit install'';
      };
    };
  });
}
