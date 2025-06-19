# Commands that are specific to Docker and Docker Compose.
function doCommand__docker__up {
  cd $SB_SRC_ROOT
  echo  "$@"
  echo  "$#"
  if [ $# -le 1 ]; then
    "${SB_DOCKER_COMPOSE_PATH}" up
  else
    "${SB_DOCKER_COMPOSE_PATH}" up "$@"
  fi
  return $?
}

function doCommand__docker__down {
  doCommand__docker__stop
}

function doCommand__docker__stop {
  cd $SB_SRC_ROOT
  if [ $# -le 1 ]; then
    "${SB_DOCKER_COMPOSE_PATH}" down
  else
    "${SB_DOCKER_COMPOSE_PATH}" down "$@"
  fi
  return $?
}

function doCommand__docker__restart {
  cd $SB_SRC_ROOT
  if [ $# -le 1 ]; then
    "${SB_DOCKER_COMPOSE_PATH}" restart
  else
    "${SB_DOCKER_COMPOSE_PATH}" restart "$@"
  fi
  return $?
}

function doCommand__docker__ps {
  "${SB_DOCKER_COMPOSE_PATH}" ps
  return $?
}
function doCommand__docker__build {
  cd $SB_SRC_ROOT
  if [ $# -le 1 ]; then
    "${SB_DOCKER_COMPOSE_PATH}" build
  else
    "${SB_DOCKER_COMPOSE_PATH}" build "$@"
  fi
  return $?
}


function doCommand__docker {
  "${SB_DOCKER_COMPOSE_PATH}" "$@"
  return $?
}