# Function that outputs SnowBlower is not running...
function isNotRunning {
	echo
	_iFail "Environment is not running." >&2
	_i "To start run" "snow up"
	exit 1
}

# Figures out the type of envirment the command is running in and then routes approriatly.
function doRoutedCommandExecute() {

	_iVerbose "Attempting to run: $*"
	# If we are inside of a SnowBlower shell we run the command directly otherwise we need to proxy the command.
	if isInsideSnowblowerShell; then
		_i "Running: $*"
		exec "$@"
		return $?
	fi

	doRunChecks

	ARGS=()
	ARGS+=(exec -u "$SB_USER_UID")
	[ ! -t 0 ] && ARGS+=(-T)
	ARGS+=("$SB_APP_SERVICE")

	_iVerbose "Executing command via docker compose"

	# Execute the command with proper shell evaluation
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" "${ARGS[@]}" "with-snowblower" "exec" "$@"
	return $?
}

function hasSubCommand() {
	local command="$1"
	local subcommand="$2"

	# Check if the function exists for this command/subcommand combination
	if declare -f "doCommand__${command}__${subcommand}" >/dev/null 2>&1; then
		return 0 # Function exists, so subcommand is valid
	else
		return 1 # Function doesn't exist, so subcommand is invalid
	fi
}

function hasHelpCommand() {
	local command="$1"

	# Check if the function exists for this command/subcommand combination
	if declare -f "doHelp__${command}" >/dev/null 2>&1; then
		return 0 # Function exists, so we can display help for it.
	else
		return 1 # Function doesn't exist, so no help is invalid
	fi
}
