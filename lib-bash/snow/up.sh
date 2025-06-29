function doSnowUpLogic() {
	# Check if SnowBlower docker container is already running
	if isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower container is already running. Use 'snow down' to stop it first."
		return 1
	fi

	# Start docker-compose detached
	$SB_DOCKER_COMPOSE_PATH -f "$SB_SRC_ROOT/docker-compose.yml" --profile auto-start up --detach --remove-orphans "$@"

	return 0
}

function doSnowUp {
	doSnowUpLogic "$@"

	doRoutedCommandExecute "service" oxker

	doSnowDownLogic

	exit 0
}
