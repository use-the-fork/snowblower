# Commands that are specific to Docker and Docker Compose.
function __sb__command__up {
  "${SB_DOCKER_COMPOSE_COMMAND[@]}" up
}

function __sb__command__stop {
  "${SB_DOCKER_COMPOSE_COMMAND[@]}" down "$@"
}

function __sb__command__restart {
  "${SB_DOCKER_COMPOSE_COMMAND[@]}" restart "$@"
}

function __sb__command__ps {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" ps
}
function __sb__command__build {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" build "$@"
}