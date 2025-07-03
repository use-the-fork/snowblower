function runNix() {                                                                                  
    $SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" run --build --rm builder nix "$@"   
}

function runBuilder() {                                                                                  
    $SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" run --build --rm builder "$@"   
}

function runDockerCompose() {                                                                                  
    $SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" "$@"   
}

function runDocker() {                                                                                  
    $SB_DOCKER_PATH "$@"   
}