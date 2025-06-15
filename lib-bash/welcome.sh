function display_help {
    echo "❄️ 💨 SnowBlower"
    echo "All Flake No Fluff"
    echo
    echo "${YELLOW}Usage:${NC}" >&2
    echo "  snow COMMAND [options] [arguments]"
    echo
    echo "${YELLOW}SnowBlower Commands:${NC}"
    echo "  ${GREEN}snow switch${NC}          Regenerate all config files."
    echo
    echo "${YELLOW}docker-compose Commands:${NC}"
    echo "  ${GREEN}snow up${NC}        Start the application"
    echo "  ${GREEN}snow up -d${NC}     Start the application in the background"
    echo "  ${GREEN}snow down${NC}      Stop the application"
    echo "  ${GREEN}snow restart${NC}   Restart the application"
    echo "  ${GREEN}snow ps${NC}        Display the status of all containers"
    echo
    __sb__displayResolvedCommands
    echo
    exit 1
}