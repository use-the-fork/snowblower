# Commands that are specific to Docker and Docker Compose.
function doCommand__docker__up {
	if [ $# -le 0 ]; then
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" up)
	else
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" up "$@")
	fi
	return $?
}

function doCommand__docker__down {
	doCommand__docker__stop
}

function doCommand__docker__stop {
	if [ $# -le 0 ]; then
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" down)
	else
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" down "$@")
	fi
	return $?
}

function doCommand__docker__restart {
	if [ $# -le 0 ]; then
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" restart)
	else
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" restart "$@")
	fi
	return $?
}

function doCommand__docker__ps {
	"${SB_DOCKER_COMPOSE_PATH}" ps
	return $?
}

function doCommand__docker__bash {
	doRoutedCommandExecute bash
	return $?
}

function doCommand__docker__build {
	if [ $# -le 0 ]; then
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" build)
	else
		(cd "$SB_SRC_ROOT" && "${SB_DOCKER_COMPOSE_PATH}" build "$@")
	fi
	return $?
}

function doCommand__docker {
	"${SB_DOCKER_COMPOSE_PATH}" "$@"
	return $?
}
