function doSnowUp {
	# Check if SnowBlower docker container is already running
	if isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower container is already running. Use 'snow down' to stop it first."
		exit 1
	fi

	# Start docker-compose detached
	$SB_DOCKER_COMPOSE_PATH -f "$SB_SRC_ROOT/docker-compose.yml" --profile auto-start up --detach --remove-orphans "$@"

	doRoutedCommandExecute "service" oxker "$@"

	doSnowDown

	exit 0
}
