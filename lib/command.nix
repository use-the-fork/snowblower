{lib, ...}: let
  formatCommand = command: let
    # Format the main command
    mainCommandLine = ''
      echo "''${YELLOW}${command.name} Commands:''${NC}"
    '';

    # Format each subcommand
    formatSubcommand = name: subcmd: ''
      echo "  ''${GREEN}snow ${command.name} ${name}''${NC}          ${subcmd.description}"
    '';

    # Combine all subcommands
    subcommandLines = lib.concatStringsSep "\n" (
      lib.mapAttrsToList formatSubcommand command.subcommands
    );
  in
    if command.subcommands != {}
    then mainCommandLine + "\n" + subcommandLines + "\necho"
    else mainCommandLine;
in {
  inherit formatCommand;
}
