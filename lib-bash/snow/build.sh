function doSnowBuildLogic() {

	_iSnow "Rebuilding"
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

function doSnowBuild() {
	doSnowBuildLogic
	exit 0
}
