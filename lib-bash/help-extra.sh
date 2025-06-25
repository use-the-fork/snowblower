# Additional help functions for internal Commands

function doHelp__snow {
	local commands=(
		# keep-sorted start
		"bash|Enter the application CLI"
		"build|Builds all containers in compose file"
		"down|Stop the application"
		"ps|Display the status of all containers"
		"reboot|Erase current session and reset vars"
		"switch|Regenerate all config files"
		"up -d|Start the application in the background"
		"update|Update all dependencies by updating the Flake (Nix flake update)"
		"up|Start the application"
		# keep-sorted end
	)

	_iCommandSection "" "SnowBlower" "${commands[@]}"
}
