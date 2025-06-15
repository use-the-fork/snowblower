# Function that outputs SnowBlower is not running...
function __sb__isNotRunning {
    errorEcho "${BOLD}SnowBlower is not running.${NC}" >&2
    echo "" >&2
    errorEcho "${BOLD}You may start docker using the following commands:${NC} 'snow up'" >&2

    exit 1
}

# Function that checks
function __sb__runChecks {
    if [ -z "$SB_SKIP_CHECKS" ]; then
        # Ensure that Docker is running...
        if ! docker info > /dev/null 2>&1; then
            errorEcho "${BOLD}Docker is not running.${NC}" >&2
            exit 1
        fi

        # Determine if SnowBlower is currently up...
        if "${DOCKER_COMPOSE[@]}" ps "$SB_APP_SERVICE" 2>&1 | grep 'Exit\|exited'; then
            warnEcho "${BOLD}Shutting down old SnowBlower processes...${NC}" >&2

            "${DOCKER_COMPOSE[@]}" down > /dev/null 2>&1

            __sb__isNotRunning
        elif [ -z "$("${DOCKER_COMPOSE[@]}" ps -q "$SB_APP_SERVICE")" ]; then
            __sb__isNotRunning
        fi
    fi
}


# Figures out the type of envirment the command is running in and then routes approriatly.
function __sb__RoutedCommandExecute() {
    local cmd="$1"
    
    # Remove surrounding quotes if present
    cmd="${cmd//\'}"
    
    # If in a nix shell, show error and exit
    if [ -n "$SB_SESS_IS_NIX_SHELL" ]; then
        eval "$cmd"
        return $?
    fi

    # If in nix shell and in docker, execute via docker-compose
    __sb__runChecks
        
    ARGS=()
    ARGS+=(exec -u "$SB_USER_UID")
    [ ! -t 0 ] && ARGS+=(-T)
    ARGS+=("$SB_APP_SERVICE")

    # Execute the command with proper shell evaluation
    "${SB_DOCKER_COMPOSE_COMMAND[@]}" "${ARGS[@]}" bash -c "$cmd"
}

# Function to run dynamically generated command functions
function __sb__runCommand {
    local command_name="$1"
    local subcommand_name="$2"
    
    # First try the specific command+subcommand function
    local specific_function="__sb__command__${command_name}__${subcommand_name}"
    
    # Then try the general command function
    local general_function="__sb__command__${command_name}"
    
    # Check if the specific function exists
    if declare -f "$specific_function" > /dev/null; then
        # Execute the specific function with remaining arguments
        shift 2
        "$specific_function" "$@"
    # Check if the general function exists
    elif declare -f "$general_function" > /dev/null; then
        # Execute the general function with all subcommands
        shift 1
        "$general_function" "$@"
    else
        errorEcho "Unknown command: snow $command_name $subcommand_name"
        errorEcho "Run 'snow help' for a list of available commands."
        exit 1
    fi
}

# Check if $2 exists before passing it to run_command                                                
if [ $# -ge 2 ]; then                                                                                
    __sb__runCommand "$1" "$2"                                                                            
else                                                                                                 
    __sb__runCommand "$1" ""                                                                              
fi