{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (lib.strings) concatMapStringsSep concatLines;

    commandModule = {
      imports = [./../lib/types/command-module.nix];
      config._module.args = {inherit pkgs;};
    };
    commandType = types.submodule commandModule;
  in {
    options.snowblower = {
      commands = mkOption {
        type = lib.sbl.types.dagOf commandType;
        default = {};
        description = ''
        '';
      };
      commandsHelpPackage = mkOption {
        type = types.package;
        internal = true;
        description = ''
          The package containing the help section of snowblower.
        '';
      };
    };

    config.snowblower = {
      commandsHelpPackage = let
        mkCommandSection = section: let
          mkSubCommandSection = name: subSection: let
            subSectionName = subSection.name;
            subSectionDescription = subSection.data.description;
          in ''
            echo "  ''${GREEN}snow ${name} ${subSectionName}''${NC}          ${subSectionDescription}"
          '';

          resolvedSubCommands = lib.sbl.dag.resolveDag {
            name = "snowblower sub commands for ${section.name} ";
            dag = section.data.subcommands;
            mapResult = subSectionResult:
              concatLines [
                (concatMapStringsSep "\n" (subCmd: mkSubCommandSection section.name subCmd) subSectionResult)
              ];
          };
        in
          concatLines [
            ''echo "''${YELLOW}${section.name} Commands:''${NC}"''
            resolvedSubCommands
          ];

        resolvedCommands = lib.sbl.dag.resolveDag {
          name = "snowblower help commands script";
          dag = config.snowblower.commands;
          mapResult = result:
            concatLines [
              (concatMapStringsSep "\n" mkCommandSection result)
            ];
        };
      in
        pkgs.writeTextFile {
          name = "sb-help-commands.sh";
          text = ''
            # Function that prints the available commands...
            function display_help {
                echo "❄️ 💨 SnowBlower"
                echo
                echo "''${YELLOW}Usage:''${NC}" >&2
                echo "  snow COMMAND [options] [arguments]"
                echo
                echo "''${YELLOW}SnowBlower Commands:''${NC}"
                echo "  ''${GREEN}snow switch''${NC}          TODO: Foo Bar"
                echo
                ${resolvedCommands}
                echo
                exit 1
            }
          '';
        };
    };
  });
}
