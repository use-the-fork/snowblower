# Function that outputs SnowBlower is not running...
function isNotRunning {
	echo
	_iFail "Environment is not running." >&2
	_iNote "To start run %s" "snow up"
	exit 1
}

# Figures out the type of envirment the command is running in and then routes approriatly.
function doRoutedCommandExecute() {

	_iVerbose "Attempting to run: $*"

	# Save the first argument (environment type) and shift it
	local env_type="$1"
	shift

	case "$env_type" in
	native)
		_iVerbose "Executing command natively"
		exec "$@"
		return $?
		;;
	tools)
		doRunChecks

		ARGS=()
		ARGS+=(exec -u "$SB_USER_UID")
		[ ! -t 0 ] && ARGS+=(-T)
		ARGS+=("$env_type")

		_iVerbose "Executing command via docker compose in %s service" $env_type

		# Execute the command with proper shell evaluation
		runDockerCompose "${ARGS[@]}" "with-snowblower" "$@"
		return $?
		;;
	service)
		doRunChecks

		# Extract the service name from the first argument
		local service_name="$1"
		shift

		_iVerbose "Executing command via docker compose run in %s service" "$service_name"

		# Execute the command using docker compose run
		runDockerCompose run --rm "$service_name" "$@"
		return $?
		;;
	*)
		_iFail "Unknown environment type: $env_type" >&2
		return 1
		;;
	esac
}