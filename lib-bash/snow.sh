# First we boot the SnowBlower Env
doBoot

PASSTHROUGH_OPTS=()
COMMAND=""
SUBCOMMAND=""
COMMAND_ARGS=()

# Phase 1: Find the main command 
while [[ $# -gt 0 ]]; do
    opt="$1"
    shift
    case $opt in
        @command_options@|switch|update|reboot)
            COMMAND="$opt"
            ;;
        -v|--verbose)
            export VERBOSE=1
            ;;
        --version)
            echo 25.11-pre
            exit 0
            ;;
        *)
            case $COMMAND in
                @command_options@|switch)
                    COMMAND_ARGS+=("$opt")
                    ;;
                *)
                    _iError "%s: unknown option '%s'" "$0" "$opt" >&2
                    _i "Run '%s --help' for usage help" "$0" >&2
                    exit 1
                    ;;
            esac
            ;;
    esac
done

# Phase 2: Parse subcommand from COMMAND_ARGS if needed                                              
if [[ -n $COMMAND && ${#COMMAND_ARGS[@]} -gt 0 ]]; then                                              
    # First argument after command could be subcommand                                               
    POTENTIAL_SUBCOMMAND="${COMMAND_ARGS[0]}"                                                        
                                                                                                     
    # Check if it's a valid subcommand for this command                                      
    if hasSubCommand "$COMMAND" "$POTENTIAL_SUBCOMMAND"; then
        SUBCOMMAND="$POTENTIAL_SUBCOMMAND"
        # Remove subcommand from args, leaving only the flags/options
        COMMAND_ARGS=("${COMMAND_ARGS[@]:1}")
    fi                                                                                               
fi  

if [[ -z $COMMAND ]]; then
    doHelp >&2
    exit 1
fi

case $COMMAND in
    @command_functions@
    docker)
    if [[ -n $SUBCOMMAND ]]; then
        if hasSubCommand "docker" "$SUBCOMMAND"; then
            doCommand__docker__$SUBCOMMAND "${COMMAND_ARGS[@]}"
        else
            doCommand__docker "${COMMAND_ARGS[@]}"
        fi
    else
        doCommand__docker "${COMMAND_ARGS[@]}"
    fi
    ;;
    switch)
        doSwitch
        ;;
    update)
        doUpdate
        ;;
    reboot)
        doUpdate
        ;;
    help)
        doHelp
        ;;
    *)
        _iError 'Unknown command: %s' "$COMMAND" >&2
        _i >&2
        exit 1
        ;;
esac
