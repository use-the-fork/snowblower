function doSnowSwitch() {

	# Check if snowblower is running
	if isSnowBlowerDockerContainerUp; then
		confirmAction "A SnowBlower Docker instance is running. This action will shut down the current instance. Continue?"

		# If it's running, run docker compose down and wait for it to finish.
		_iOk "Stopping SnowBlower services..."

		doSnowDownLogic
	fi

	doSnowBuildImagesLogic

	_iNote "Running file generator..."
	doSnowBuildFilesLogic

	_iHeart "Switch Complete"

	exit 0
}
