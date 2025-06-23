function doSnowDown {

	# Check if snowblower is running
	if ! isSnowBlowerDockerContainerUp; then
		_iExit "SnowBlower is already down."
		exit 0
	fi

	# If it's running, run docker compose down and wait for it to finish then run doDestroySession
	_iOk "Stopping SnowBlower services..."
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" down

	# Wait for docker compose to finish, then destroy session
	doDestroySession

	_iOk "SnowBlower has been stopped."
	exit 0
}
