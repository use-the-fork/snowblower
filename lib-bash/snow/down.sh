function doSnowDownLogic() {
	# Check if snowblower is running
	if ! isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower is already down."
		return 1
	fi

	# If it's running, run docker compose down and wait for it to finish then run doDestroySession
	_iOk "Stopping SnowBlower services..."
	$SB_DOCKER_COMPOSE_PATH -f "$SB_SRC_ROOT/docker-compose.yml" --profile auto-start down --remove-orphans

	_iCloud "SnowBlower has been stopped."
	return 0
}

function doSnowDown {
	doSnowDownLogic
	exit 0
}
