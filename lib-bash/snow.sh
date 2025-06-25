PASSTHROUGH_OPTS=()

SNOW_COMMAND=""
SNOW_COMMAND_ARGS=()

COMMAND=""
SUBCOMMAND=""
COMMAND_ARGS=()

# Split arguments at the `--` separator
BEFORE_SEPARATOR=()
AFTER_SEPARATOR=()

# Used here to split the function in to anything before '--' and after.
FOUND_SEPARATOR=false
for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
        FOUND_SEPARATOR=true
        continue
    fi
    
    if [[ "$FOUND_SEPARATOR" == true ]]; then
        AFTER_SEPARATOR+=("$arg")
    else
        BEFORE_SEPARATOR+=("$arg")
    fi
done


# Process snow-specific options and commands before `--`
i=0
while [[ $i -lt ${#BEFORE_SEPARATOR[@]} ]]; do
    opt="${BEFORE_SEPARATOR[$i]}"
    i=$((i+1))
    
    case $opt in
        -v|--verbose)
            export VERBOSE=1
            ;;
        -h|--help)
            export HELP=1
            ;;
        --version)
            echo 25.11-pre
            exit 0
            ;;
        switch|up|down|update|reboot|help)
            SNOW_COMMAND="$opt"
            ;;
        *)
            case $SNOW_COMMAND in
                switch|update|reboot|up|down|help)
                    SNOW_COMMAND_ARGS+=("$opt")
                    ;;
                *)
                    if [[ -z $SNOW_COMMAND ]]; then
                        _iError "%s: unknown snow option '%s'. Use format: snow [options] -- command [args]" "$0" "$opt" >&2
                        exit 1
                    else
                        SNOW_COMMAND_ARGS+=("$opt")
                    fi
                    ;;
            esac
            ;;
    esac
done

# Process environment commands and subcommands from after `--`
i=0
while [[ $i -lt ${#AFTER_SEPARATOR[@]} ]]; do
    opt="${AFTER_SEPARATOR[$i]}"
    i=$((i+1))    
            case $opt in
            @command_options@)
                export COMMAND="$opt"
                ;;
            *)
                case $COMMAND in
                    @command_options@)
                        export COMMAND_ARGS+=("$opt")
                        ;;
                    *)
                        if [[ -z $COMMAND ]]; then
                            _iError "%s: unknown command '%s'" "$0" "$opt" >&2
                            _i "Run '%s --help' for usage help" "$0" >&2
                            exit 1
                        else
                            export COMMAND_ARGS+=("$opt")
                        fi
                        ;;
                esac
                ;;
        esac
done

# Welcome Message
_iSnow "SnowBlower: All flake no fluff."

# find and set the root early on since we use it in our snow commands
doSetRoot

# we check the system to make sure we can run `SnowBlower`
doCheckSystem

# Now we setup our global vars
doSetupSession

# Lets GOOOO!!!!!
doBoot

# Parse subcommand from COMMAND_ARGS if needed
# This works becuase a sub command must come after a command
if [[ -n $COMMAND && ${#COMMAND_ARGS[@]} -gt 0 ]]; then
    potential_subcommand="${COMMAND_ARGS[0]}"
    
    if hasSubCommand "$COMMAND" "$potential_subcommand"; then
        export SUBCOMMAND="$potential_subcommand"
        export COMMAND_ARGS=("${COMMAND_ARGS[@]:1}")
    fi
fi

# Check if no `--` was found and no snow command was specified
if [[ "$found_separator" == false && -z $SNOW_COMMAND ]]; then
    doHelp >&2
    exit 1
fi

if [[ -n $HELP && -n $COMMAND ]]; then
  if hasHelpCommand "$COMMAND"; then
      doHelp__$COMMAND
      exit 1
  fi
fi

# Handle snow-specific commands first
if [[ -n $SNOW_COMMAND ]]; then
    case $SNOW_COMMAND in
        switch)
            doSnowSwitch "${SNOW_COMMAND_ARGS[@]}"
            ;;
        up)
            doSnowUp "${SNOW_COMMAND_ARGS[@]}"
            ;;
        down)
            doSnowDown "${SNOW_COMMAND_ARGS[@]}"
            ;;
        update)
            doSnowUpdate "${SNOW_COMMAND_ARGS[@]}"
            ;;
        reboot)
            doSnowReboot "${SNOW_COMMAND_ARGS[@]}"
            ;;
        help)
            doHelp "${SNOW_COMMAND_ARGS[@]}"
            ;;
        *)
            _iError 'Unknown snow command: %s' "$SNOW_COMMAND" >&2
            exit 1
            ;;
    esac
    exit 0
fi

# Handle environment commands
if [[ -z $COMMAND ]]; then
    doHelp >&2
    exit 1
fi

# None of the below should be run if SnowBlower is not up.
isSnowBlowerUp

case $COMMAND in
    @command_functions@
    *)
        _iError 'Unknown command: %s' "$COMMAND" >&2
        _i >&2
        exit 1
        ;;
esac
