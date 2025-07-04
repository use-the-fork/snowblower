function runNix() {
	if [[ $BUILD == "1" ]]; then
		run_args+=(--build)
	fi

	run_args+=(--rm builder)

	$SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" run "${run_args[@]}" "$@"
}

function runBuilder() {
	local run_args=()

	if [[ $BUILD == "1" ]]; then
		run_args+=(--build)
	fi

	run_args+=(--rm builder)

	$SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" run "${run_args[@]}" "$@"
}

function runDockerCompose() {
	local compose_args=()

	if [[ $BUILD == "1" ]]; then
		compose_args+=(--build)
	fi

	compose_args+=(-f "$SB_WORKSPACE_ROOT/docker-compose.yml")

	$SB_DOCKER_PATH compose "${compose_args[@]}" "$@"
}

function runDocker() {
	$SB_DOCKER_PATH "$@"
}
