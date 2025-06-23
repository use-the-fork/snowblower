function doSnowUp {

	# Check if SnowBlower docker container is already running
	if isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower container is already running. Use 'snow down' to stop it first."
		exit 1
	fi

	# Start docker-compose with interactive menu
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" up "$@" &
	DOCKER_COMPOSE_PID=$!

	# Wait for the process if not running in detached mode
	if [[ ! $* =~ -d|--detach ]]; then
		wait $DOCKER_COMPOSE_PID
	fi

	exit 0
}
