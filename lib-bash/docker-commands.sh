# Commands that are specific to Docker and Docker Compose.
function __sb__command__up {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" up
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" up "$@"
    fi
}

function __sb__command__down {
    __sb__command__stop
}

function __sb__command__stop {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" down
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" down "$@"
    fi
}

function __sb__command__restart {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" restart
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" restart "$@"
    fi
}

function __sb__command__ps {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" ps
}
function __sb__command__build {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" build
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" build "$@"
    fi
}