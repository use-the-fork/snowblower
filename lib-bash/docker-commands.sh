# Commands that are specific to Docker and Docker Compose.
function __sb__command__up {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" up
  docker-compose up "$@"
}

function __sb__command__stop {
  docker-compose down "$@"
}

function __sb__command__restart {
  docker-compose restart "$@"
}

function __sb__command__ps {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" ps
}