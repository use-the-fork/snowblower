function doSnowPsLogic() {

	# Check if snowblower is running
	if ! isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower is already down."
		return 1
	fi

	$SB_DOCKER_PATH -f "$SB_SRC_ROOT/docker-compose.yml" ps

	return 0
}

function doSnowPs {
	doSnowPsLogic
	exit 0
}
