function doSnowBuild() {

	_iNote "Rebuilding"

	rm -f ./result
	_iNote "Building Runtime Docker Image"
	$SB_NIX_PATH build --impure .#dockerRuntimeImagePackage

	_iNote "Loading Runtime Docker Image"
	$SB_DOCKER_PATH load -i ./result
	rm ./result

	_iNote "Building Tooling Docker Image"
	$SB_NIX_PATH build --impure .#dockerToolsImagePackage

	_iNote "Loading Tooling Docker Image"
	$SB_DOCKER_PATH load -i ./result

	exit 0
}
