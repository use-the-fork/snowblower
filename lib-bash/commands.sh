# Function that outputs SnowBlower is not running...
function isNotRunning {
  echo
  _iFail "Environment is not running." >&2
  _i "To start run" "snow docker up"
  exit 1
}

# Function that checks
function doRunChecks {
  if [ -z "$SB_SKIP_CHECKS" ]; then
    # Ensure that Docker is running...
    if ! docker info >/dev/null 2>&1; then
      _iFail "${BOLD}Docker is not running.${NC}" >&2
      exit 1
    fi

    # Determine if SnowBlower is currently up...
    if "${SB_DOCKER_COMPOSE_PATH[@]}" ps "$SB_APP_SERVICE" 2>&1 | grep 'Exit\|exited'; then
      _iWarn "${BOLD}Shutting down old SnowBlower processes...${NC}" >&2
      "${SB_DOCKER_COMPOSE_PATH[@]}" down >/dev/null 2>&1
      isNotRunning
    elif [ -z "$("${SB_DOCKER_COMPOSE_PATH[@]}" ps -q "$SB_APP_SERVICE")" ]; then
      isNotRunning
    fi
  fi
}

# Figures out the type of envirment the command is running in and then routes approriatly.
function doRoutedCommandExecute() {
  _iVerbose "Attempting to run: $*"
  # If we are inside of a SnowBlower shell we run the command directly otherwise we need to proxy the command.
  if isInsideSnowblowerShell; then
    _i "Running: $*"
    exec "$@"
    return $?
  fi

  # If in nix shell and in docker, execute via docker-compose
  doRunChecks

  ARGS=()
  ARGS+=(exec -u "$SB_USER_UID")
  [ ! -t 0 ] && ARGS+=(-T)
  ARGS+=("$SB_APP_SERVICE")

  _iVerbose "Executing command via docker compose"
  # Execute the command with proper shell evaluation
  "${SB_DOCKER_COMPOSE_PATH[@]}" "${ARGS[@]}" with-nix "$@"
  return $?
}

function hasSubCommand() {
    local command="$1"
    local subcommand="$2"
    
    # Check if the function exists for this command/subcommand combination
    if declare -f "doCommand__${command}__${subcommand}" >/dev/null 2>&1; then
        return 0  # Function exists, so subcommand is valid                                          
    else                                                                                             
        return 1  # Function doesn't exist, so subcommand is invalid                                 
    fi                                                                                               
}   