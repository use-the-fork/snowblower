            function display_help {
                echo "❄️ 💨 SnowBlower"
                echo "All Flake No Fluff"
                echo
                echo "''${YELLOW}Usage:''${NC}" >&2
                echo "  snow COMMAND [options] [arguments]"
                echo
                echo "''${YELLOW}SnowBlower Commands:''${NC}"
                echo "  ''${GREEN}snow switch''${NC}          TODO: Foo Bar"
                echo
                __sb__displayResolvedCommands
                echo
                exit 1
            }