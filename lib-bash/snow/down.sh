function doSnowDownLogic() {
	# Check if snowblower is running
	if ! isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower is already down."
		return 1
	fi

	# Execute down hooks
	doHook__up__post

	# If it's running, run docker compose down and wait for it to finish then run doDestroySession
	_iOk "Stopping SnowBlower services..."
	runDockerCompose --profile auto-start down --remove-orphans

	_iHeart "SnowBlower has been stopped."
	return 0
}

function doSnowDown {
	doSnowDownLogic
	exit 0
}
