# Function that outputs SnowBlower is not running...
function __sb__isNotRunning {
    echo "${BOLD}SnowBlower is not running.${NC}" >&2
    echo "" >&2
    echo "${BOLD}You may start docker using the following commands:${NC} './snow up'" >&2

    exit 1
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

# TODO: This should prob be handled in the run_command function.
# Check if $2 exists before passing it to run_command                                                
if [ $# -ge 2 ]; then                                                                                
    __sb__runCommand "$1" "$2"                                                                            
else                                                                                                 
    __sb__runCommand "$1" ""                                                                              
fi 
