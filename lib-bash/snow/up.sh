function doSnowUpLogic() {
	# Execute pre-up hooks
	doHook__up__pre

	# Check if SnowBlower docker container is already running
	if isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower container is already running. Use 'snow down' to stop it first."
		return 1
	fi

	# Start docker-compose detached
	$SB_DOCKER_COMPOSE_PATH -f "$SB_SRC_ROOT/docker-compose.yml" --profile auto-start up --detach --remove-orphans "$@"
	doRoutedCommandExecute "tools" "snowblower-hooks" "tools_pre"

	return 0
}

function doSnowUp {

	doSnowUpLogic "$@"
	if [ $? -eq 1 ]; then
		exit 1
	fi

	doRoutedCommandExecute "service" oxker

	doRoutedCommandExecute "tools" "snowblower-hooks" "tools_post"
	doSnowDownLogic

	exit 0
}
