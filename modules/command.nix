{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.strings) concatMapStringsSep concatLines optionalString;

    commandModule = {
      imports = [./../lib/types/command-module.nix];
      config._module.args = {inherit pkgs;};
    };
    commandType = types.submodule commandModule;
  in {
    options.snowblower = {
      command = mkOption {
        type = lib.sbl.types.dagOf commandType;
        default = {};
        description = ''
        '';
      };
      commandHelpPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package containing the help section of snowblower.
        '';
      };

      commandPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package containing the wrapped commands section of snowblower.
        '';
      };
    };

    config.snowblower = {
      commandHelpPackage = let
        mkCommandHelpFunction = section: let
          mkSubCommandOption = name: subSection: let
            subSectionName = subSection.name;
            subSectionDescription = subSection.data.description;
          in
            if subSection.data.internal
            then ""
            else "${subSectionName}|${subSectionDescription}";

          resolvedSubCommands = lib.sbl.dag.resolveDag {
            name = "snowblower sub commands for ${section.name}";
            dag = section.data.shortcut;
            mapResult = subSectionResult:
              lib.filter (x: x != "") (map (subCmd: mkSubCommandOption section.name subCmd) subSectionResult);
          };

          # Build the options array for _iCommandSection
          baseOption = optionalString (section.data.command != null) "...|Run a ${section.data.displayName} command";
          allOptions = lib.filter (x: x != "") ([baseOption] ++ resolvedSubCommands);
          optionsArray = "(" + (lib.concatStringsSep " " (map lib.strings.escapeShellArg allOptions)) + ")";
        in
          if section.data.internal
          then ""
          else ''
            function doHelp__${section.name} {
              local commands=${optionsArray}
              _iCommandSection "${section.name}" "${section.data.displayName}" "''${commands[@]}"
            }
          '';

        resolvedHelpFunctions = lib.sbl.dag.resolveDag {
          name = "snowblower help functions";
          dag = config.snowblower.command;
          mapResult = result:
            concatLines (map mkCommandHelpFunction result);
        };

        # Generate calls to all help functions for displayAllResolvedCommands
        callResolvedCommands = lib.sbl.dag.resolveDag {
          name = "snowblower help function calls";
          dag = config.snowblower.command;
          mapResult = result:
            concatLines (map (
              section:
                if section.data.internal
                then ""
                else "doHelp__${section.name}"
            ) (lib.filter (section: !section.data.internal) result));
        };
      in
        pkgs.writeTextFile {
          name = "sb-help-commands.sh";
          # Prints the resolved commands from the nix build.
          text = ''
            function displayAllResolvedCommands {
              doHelp__snow
              ${callResolvedCommands}
            }
            ${resolvedHelpFunctions}
          '';
        };

      commandPackage = let
        # Generate the command options list (e.g., "docker|npm|switch|update|reboot")
        commandOptions = lib.concatStringsSep "|" (
          map (section: section.name)
          (lib.sbl.dag.resolveDag {
            name = "snowblower command options";
            dag = config.snowblower.command;
            mapResult = lib.id;
          })
        );

        # Generate the command case statements
        commandFunctions = lib.sbl.dag.resolveDag {
          name = "snowblower command functions";
          dag = config.snowblower.command;
          mapResult = result:
            concatLines (map (section: ''
              ${section.name})
                  if [[ -n $SUBCOMMAND ]]; then
                      if hasSubCommand "${section.name}" "$SUBCOMMAND"; then
                          doCommand__${section.name}__$SUBCOMMAND "''${COMMAND_ARGS[@]}"
                      else
                          doCommand__${section.name} "''${COMMAND_ARGS[@]}"
                      fi
                  else
                      doCommand__${section.name} "''${COMMAND_ARGS[@]}"
                  fi
                  ;;'')
            result);
        };

        mkCommandSection = section: let
          mkSubCommandSection = name: subSection: let
            subSectionName = subSection.name;
            # Generate proper bash array from command and args
            commandParts = [section.data.command] ++ subSection.data.args;
            execArray = "(" + (lib.concatStringsSep " " (map lib.strings.escapeShellArg commandParts)) + ")";
          in ''
            function doCommand__${name}__${subSectionName} {
              local cmd_args=${execArray}
              doRoutedCommandExecute "''${cmd_args[@]}" "$@"
            }
          '';

          resolvedSubCommands = lib.sbl.dag.resolveDag {
            name = "snowblower sub commands for ${section.name} ";
            dag = section.data.shortcut;
            mapResult = subSectionResult:
              concatLines [
                (concatMapStringsSep "\n" (subCmd: mkSubCommandSection section.name subCmd) subSectionResult)
              ];
          };
        in
          concatLines [
            (optionalString (section.data.command != null) ''function doCommand__${section.name} { doRoutedCommandExecute ${lib.strings.escapeShellArg section.data.command} "$@"; }'')
            resolvedSubCommands
          ];

        resolvedCommands = lib.sbl.dag.resolveDag {
          name = "snowblower run commands script";
          dag = config.snowblower.command;
          mapResult = result:
            concatLines [
              (concatMapStringsSep "\n" mkCommandSection result)
            ];
        };

        # Read snow.sh and perform replacements
        snowShellContent = lib.sbl.strings.modifyFileContent {
          file = ./../lib-bash/snow/main.sh;
          substitute = {
            "@command_options@" = commandOptions;
            "@command_functions@" = commandFunctions;
          };
        };
      in
        pkgs.writeTextFile {
          name = "sb-run-commands.sh";
          text = ''
            ${resolvedCommands}

            # keep-sorted start
            ${builtins.readFile ./../lib-bash/commands.sh}
            ${builtins.readFile ./../lib-bash/docker-commands.sh}
            ${builtins.readFile ./../lib-bash/snow-commands.sh}
            ${builtins.readFile ./../lib-bash/snow/build.sh}
            ${builtins.readFile ./../lib-bash/snow/down.sh}
            ${builtins.readFile ./../lib-bash/snow/switch.sh}
            ${builtins.readFile ./../lib-bash/snow/up.sh}
            # keep-sorted end

            ${snowShellContent}
          '';
        };
    };
  });
}
