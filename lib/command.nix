{lib, ...}: let
  formatCommand = command: let
    # Format the main command
    commandLine = ''
      echo "''${YELLOW}${command.name} Commands:''${NC}"
    '';

    # Format each shortcut
    formatShortcut = name: shortcut: ''
      echo "  ''${GREEN}snow ${command.name} ${name}''${NC}          ${shortcut.description}"
    '';

    # Combine all shortcuts
    shortcutLines = lib.concatStringsSep "\n" (
      lib.mapAttrsToList formatShortcut command.shortcuts
    );
  in
    if command.shortcut != {}
    then commandLine + "\n" + shortcutLines + "\necho"
    else commandLine;
in {
  inherit formatCommand;
}
