function doSnowBuildImagesLogic() {

	_iSnow "Rebuilding Images"

	_iNote "Pruning Old Images"
	ensure runDocker image prune -f --filter "label=org.snowblower.project=$SB_PROJECT_HASH"
	_iOk "Pruned Images"
	
	rm -f "$SB_PROJECT_ROOT/result"

	_iNote "Building Runtime Docker Image"
	ensure runBuilder nix build --impure --out-link "/snowblower/result" .#dockerRuntimeImagePackage
	_iOk "Built Runtime Docker Image"
	
	_iNote "Loading Runtime Docker Image"
	ensure runBuilder bash -c "/snowblower/result | sudo docker load"
	_iOk "Loaded Runtime Docker Image"

	rm -f "$SB_PROJECT_ROOT/result"
	
	_iNote "Building Tooling Docker Image"
	ensure runBuilder nix build --impure --out-link "/snowblower/result" .#dockerToolsImagePackage
	_iOk "Built Tooling Docker Image"

	
	_iNote "Loading Tooling Docker Image"
	ensure runBuilder bash -c "/snowblower/result | sudo docker load"
	_iOk "Loaded Tooling Docker Image"

	rm -f "$SB_PROJECT_ROOT/result"

	_iHeart "Build Complete"

	return 0
}

function doSnowBuildFilesLogic() {
	runBuilder bash -c "nix run --impure .#snowblowerFiles -L"
	return 0
}

function doSnowBuild() {

	local build_files=false
	local build_images=false

	# If no arguments are passed, run both
	if [[ $# -eq 0 ]]; then
		build_files=true
		build_images=true
	else
		# Check arguments
		for arg in "$@"; do
			if [[ $arg == "-f" || $arg == "--files" ]]; then
				build_files=true
			elif [[ $arg == "-i" || $arg == "--images" ]]; then
				build_images=true
			fi
		done

		# If no recognized arguments, default to both
		if [[ $build_files == false && $build_images == false ]]; then
			build_files=true
			build_images=true
		fi
	fi

	# Always build files first if requested
	if [[ $build_files == true ]]; then
		doSnowBuildFilesLogic
	fi

	# Then build images if requested
	if [[ $build_images == true ]]; then
		doSnowBuildImagesLogic
	fi

	exit 0
}
