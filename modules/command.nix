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
      commandRunPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package containing the wrapped commands section of snowblower.
        '';
      };
    };

    config.snowblower = {
      commandHelpPackage = let
        mkCommandSection = section: let
          mkSubCommandSection = name: subSection: let
            subSectionName = subSection.name;
            subSectionDescription = subSection.data.description;
          in
            if subSection.data.internal
            then ""
            else ''echo "  ''${GREEN}snow ${name} ${subSectionName}''${NC}          ${subSectionDescription}"'';

          resolvedSubCommands = lib.sbl.dag.resolveDag {
            name = "snowblower sub commands for ${section.name} ";
            dag = section.data.subcommand;
            mapResult = subSectionResult:
              concatLines [
                (concatMapStringsSep "\n" (subCmd: mkSubCommandSection section.name subCmd) subSectionResult)
              ];
          };
        in
          if section.data.internal
          then ""
          else
            concatLines [
              ''echo "''${YELLOW}${section.data.displayName} Commands:''${NC}"''
              (
                optionalString (section.data.exec != null)
                ''echo "  ''${GREEN}snow ${section.name} ...''${NC}          Run a ${section.data.displayName} command"''
              )
              resolvedSubCommands
              ''echo''
            ];

        resolvedCommands = lib.sbl.dag.resolveDag {
          name = "snowblower help commands script";
          dag = config.snowblower.command;
          mapResult = result:
            concatLines [
              (concatMapStringsSep "\n" mkCommandSection result)
            ];
        };
      in
        pkgs.writeTextFile {
          name = "sb-help-commands.sh";
          # Prints the resolved commands from the nix build.
          text = ''            function __sb__displayResolvedCommands {
                        ${resolvedCommands}
                      }
          '';
        };

      commandRunPackage = let
        mkCommandSection = section: let
          mkSubCommandSection = name: subSection: let
            subSectionName = subSection.name;
          in ''            function __sb__command__${name}__${subSectionName} {
                            __sb__RoutedCommandExecute ${lib.strings.escapeShellArg subSection.data.exec} "$@"
                           }'';

          resolvedSubCommands = lib.sbl.dag.resolveDag {
            name = "snowblower sub commands for ${section.name} ";
            dag = section.data.subcommand;
            mapResult = subSectionResult:
              concatLines [
                (concatMapStringsSep "\n" (subCmd: mkSubCommandSection section.name subCmd) subSectionResult)
              ];
          };
        in
          concatLines [
            (optionalString (section.data.exec != null) ''
              function __sb__command__${section.name} {
                __sb__RoutedCommandExecute ${lib.strings.escapeShellArg section.data.exec} "$@"
              }
            '')
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
      in
        pkgs.writeTextFile {
          name = "sb-run-commands.sh";
          text = ''
            ${resolvedCommands}
            ${builtins.readFile ./../lib-bash/commands.sh}
          '';
        };
    };
  });
}
