function doSnowSwitch() {

	# Check if snowblower is running
	if isSnowBlowerDockerContainerUp; then
		confirmAction "A SnowBlower Docker instance is running. This action will shut down the current instance. Continue?"

		# If it's running, run docker compose down and wait for it to finish then run doDestroySession
		_iOk "Stopping SnowBlower services..."
		"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" down
	fi

	_iNote "Rebuilding"

	rm ./result
	_iNote "Building Runtime Docker Image"
	nix build .#dockerRuntimeImagePackage

	_iNote "Loading Runtime Docker Image"
	docker load -i ./result
	rm ./result

	_iNote "Building Tooling Docker Image"
	nix build .#dockerToolsImagePackage

	_iNote "Loading Tooling Docker Image"
	docker load -i ./result
	rm ./result
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" build

	# Start Docker in detached mode
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" up -d &
	DOCKER_COMPOSE_PID=$!

	wait $DOCKER_COMPOSE_PID

	_iNote "Running file generator..."
	doRoutedCommandExecute snowblower-files

	# Take it back down
	"$SB_DOCKER_COMPOSE_PATH" -f "$SB_SRC_ROOT/docker-compose.yml" down

	_iCloud "Switch Complete"

	# Wait for docker compose to finish, then destroy session
	doDestroySession

	exit 0
}
