function doSnowBuildImagesLogic() {

	_iSnow "Rebuilding Images"

	_iWithSpinner "Pruning Old Images" $SB_DOCKER_PATH image prune -f --filter "label=org.snowblower.project=$SB_PROJECT_HASH"

	rm -f "$SB_PROJECT_ROOT/result"

	_iWithSpinner "Building Runtime Docker Image" $SB_NIX_PATH build --impure --out-link "$SB_PROJECT_ROOT/result" .#dockerRuntimeImagePackage
	_iWithSpinner "Loading Runtime Docker Image" $SB_DOCKER_PATH load -i "$SB_PROJECT_ROOT/result"

	rm -f "$SB_PROJECT_ROOT/result"

	_iWithSpinner "Building Tooling Docker Image" $SB_NIX_PATH build --impure --out-link "$SB_PROJECT_ROOT/result" .#dockerToolsImagePackage
	_iWithSpinner "Loading Tooling Docker Image" $SB_DOCKER_PATH load -i "$SB_PROJECT_ROOT/result"

	rm -f "$SB_PROJECT_ROOT/result"

	_iHeart "Build Complete"

	return 0
}

function doSnowBuildFilesLogic() {
	$SB_NIX_PATH run --impure .#snowblowerFiles -L
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
