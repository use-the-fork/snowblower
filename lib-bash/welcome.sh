function doHelp {
	echo "${YELLOW}Usage:${NC}" >&2
	echo "  snow [options] COMMAND SUBCOMMAND [arguments]"
	echo
	displayAllResolvedCommands
	echo
	exit 1
}
