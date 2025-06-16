# Function that outputs SnowBlower is not running...
function __sb__isNotRunning {
    echoFail "${BOLD}SnowBlower is not running.${NC}" >&2
    echo "" >&2
    echoFail "${BOLD}You may start docker using the following commands:${NC} 'snow up'" >&2

    exit 1
}

# Function that checks
function __sb__runChecks {
    if [ -z "$SB_SKIP_CHECKS" ]; then
        # Ensure that Docker is running...
        if ! docker info > /dev/null 2>&1; then
            echoFail "${BOLD}Docker is not running.${NC}" >&2
            exit 1
        fi

        # Determine if SnowBlower is currently up...
        if "${SB_DOCKER_COMPOSE_PATH[@]}" ps "$SB_APP_SERVICE" 2>&1 | grep 'Exit\|exited'; then
            echoWarn "${BOLD}Shutting down old SnowBlower processes...${NC}" >&2
            "${SB_DOCKER_COMPOSE_PATH[@]}" down > /dev/null 2>&1
            __sb__isNotRunning
        elif [ -z "$("${SB_DOCKER_COMPOSE_PATH[@]}" ps -q "$SB_APP_SERVICE")" ]; then
            __sb__isNotRunning
        fi
    fi
}


# Figures out the type of envirment the command is running in and then routes approriatly.
function __sb__RoutedCommandExecute() {
    local cmd="$1"
    
    # Remove surrounding quotes if present
    cmd="${cmd//\'}"
    
    # If the env has Nix we can run the command directly
    if __sb__hasNix; then
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
    "${SB_DOCKER_COMPOSE_PATH[@]}" "${ARGS[@]}" bash -c "$cmd"
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
        echoFail "Unknown command: snow $command_name $subcommand_name"
        echoBlank "Run 'snow help' for a list of available commands."
        exit 1
    fi
}

# Check if $2 exists before passing it to run_command                                                
if [ $# -ge 2 ]; then                                                                                
    __sb__runCommand "$1" "$2"                                                                            
else                                                                                                 
    __sb__runCommand "$1" ""                                                                              
fi