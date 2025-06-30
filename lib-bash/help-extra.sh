# Additional help functions for internal Commands

function doHelp__snow {
	local commands=(
		# keep-sorted start
		"build|Builds all containers in compose file"
		"down|Stop the application"
		"ps|Display the status of all containers"
		"reboot|Erase current session and reset vars"
		"switch|Regenerate all config files"
		"update|Update all dependencies by updating the Flake (Nix flake update)"
		"up|Start the application"
		# keep-sorted end
	)

	_iCommandSection "" "SnowBlower" "${commands[@]}"
}
