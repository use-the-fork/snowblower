# Commands that are specific to Docker and Docker Compose.
function __sb__command__docker__up {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" up
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" up "$@"
    fi
    return $?
}

function __sb__command__docker__down {
    __sb__command__docker__stop
}

function __sb__command__docker__stop {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" down
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" down "$@"
    fi
    return $?
}

function __sb__command__docker__restart {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" restart
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" restart "$@"
    fi
    return $?
}

function __sb__command__docker__ps {
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" ps
    return $?
}
function __sb__command__docker__build {
    if [ $# -le 1 ]; then
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" build
    else                                
        "${SB_DOCKER_COMPOSE_COMMAND[@]}" build "$@"
    fi
    return $?
}