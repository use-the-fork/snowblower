PASSTHROUGH_OPTS=()

SNOW_COMMAND=""
SNOW_COMMAND_ARGS=()

COMMAND=""
SUBCOMMAND=""
COMMAND_ARGS=()

# Split arguments at the `--` separator
BEFORE_SEPARATOR=()
AFTER_SEPARATOR=()

# Used here to split the function in to anything before '--' and after.
FOUND_SEPARATOR=false
for arg in "$@"; do
	if [[ $arg == "--" ]]; then
		FOUND_SEPARATOR=true
		continue
	fi

	if [[ $FOUND_SEPARATOR == true ]]; then
		AFTER_SEPARATOR+=("$arg")
	else
		BEFORE_SEPARATOR+=("$arg")
	fi
done

# Process snow-specific options and commands before `--`
i=0
while [[ $i -lt ${#BEFORE_SEPARATOR[@]} ]]; do
	opt="${BEFORE_SEPARATOR[$i]}"
	i=$((i + 1))

	case $opt in
	-v | --verbose)
		export VERBOSE=1
		;;
	-h | --help)
		export HELP=1
		;;
	-b | --build)
		export BUILD=1
		;;
	--version)
		echo 25.11-pre
		exit 0
		;;
	switch | up | down | update | reboot | build | ps | bash | dev | help)
		SNOW_COMMAND="$opt"
		;;
	*)
		case $SNOW_COMMAND in
		switch | update | reboot | up | down | build | ps | bash | dev | help)
			SNOW_COMMAND_ARGS+=("$opt")
			;;
		*)
			if [[ -z $SNOW_COMMAND ]]; then
				_iError "%s: unknown snow option '%s'. Use format: snow [options] -- command [args]" "$0" "$opt" >&2
				exit 1
			else
				SNOW_COMMAND_ARGS+=("$opt")
			fi
			;;
		esac
		;;
	esac
done

# Lets GOOOO!!!!!
doBoot

# Check if no `--` was found and no snow command was specified
if [[ $found_separator == false && -z $SNOW_COMMAND ]]; then
	doHelp >&2
	exit 1
fi

# Handle snow-specific commands first
if [[ -n $SNOW_COMMAND ]]; then
	case $SNOW_COMMAND in
	# keep-sorted start
	bash)
		doSnowBash "${SNOW_COMMAND_ARGS[@]}"
		;;
	build)
		doSnowBuild "${SNOW_COMMAND_ARGS[@]}"
		;;
	dev)
		doSnowDev "${SNOW_COMMAND_ARGS[@]}"
		;;
	down)
		doSnowDown "${SNOW_COMMAND_ARGS[@]}"
		;;
	ps)
		doSnowPs "${SNOW_COMMAND_ARGS[@]}"
		;;
	reboot)
		doSnowReboot "${SNOW_COMMAND_ARGS[@]}"
		;;
	switch)
		doSnowSwitch "${SNOW_COMMAND_ARGS[@]}"
		;;
	up)
		doSnowUp "${SNOW_COMMAND_ARGS[@]}"
		;;
	update)
		doSnowUpdate "${SNOW_COMMAND_ARGS[@]}"
		;;
	# keep-sorted end
	help)
		doHelp "${SNOW_COMMAND_ARGS[@]}"
		;;
	*)
		_iError 'Unknown snow command: %s' "$SNOW_COMMAND" >&2
		exit 1
		;;
	esac
	exit 0
fi

# None of the below should be run if SnowBlower is not up.
isSnowBlowerUp

doRoutedCommandExecute tools "${AFTER_SEPARATOR[@]}"
