# Commands that are specific to controling SnowBlower.
function doSnowUpdate {

	doRoutedCommandExecute nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes
	doSnowSwitch
	return 0
}

function doSnowReboot() {

	# Check if snowblower is running
	if isSnowBlowerDockerContainerUp; then
		confirmAction "A SnowBlower Docker instance is running. This action will shut down the current instance. Continue?"
	fi

	doSnowDown
	doSnowUp
	exit 0
}