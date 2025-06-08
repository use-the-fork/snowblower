# Function that prints the available commands...
function display_help {
    echo "❄️ 💨 SnowBlower"
    echo
    echo "${YELLOW}Usage:${NC}" >&2
    echo "  snow COMMAND [options] [arguments]"
    echo
    echo "${YELLOW}Core Commands:${NC}"
    echo "  ${GREEN}snow switch${NC}          TODO: Foo Bar"
    echo "  ${GREEN}snow artisan queue:work${NC}"
    echo
    echo "${YELLOW}PHP Commands:${NC}"
    echo "  ${GREEN}snow php ...${NC}   Run a snippet of PHP code"
    echo "  ${GREEN}snow php -v${NC}"
    echo


    exit 1
}


# Proxy the "help" command...
if [ $# -gt 0 ]; then
    if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]; then
        display_help
    fi
else
    display_help
fi