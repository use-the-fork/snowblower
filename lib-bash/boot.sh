UNAMEOUT="$(uname -s)"

# Verify operating system is supported...
case "${UNAMEOUT}" in
    Linux*)             MACHINE=linux;;
    Darwin*)            MACHINE=mac;;
    *)                  MACHINE="UNKNOWN"
esac

if [ "$MACHINE" == "UNKNOWN" ]; then
    echoFail "Unsupported operating system [$(uname -s)]." "SnowBlower supports macOS, Linux, and Windows (WSL2)." >&2
    exit 1
fi


# Source the ".env" file so environment variables are available...
# shellcheck source=/dev/null
if [ -n "${APP_ENV+x}" ] && [ -n "$APP_ENV" ] && [ -f ./.env."$APP_ENV" ]; then
  source ./.env."$APP_ENV";
  echoOk "Found and sources" ".env.{$APP_ENV}"
elif [ -f ./.env ]; then
  source ./.env;
  echoOk "Found and sourced" ".env"
fi
``
# Create a session file in tmp dir. this allows us to do the "heavy" lifiting for the snow command one time.
SCRIPT_HASH=$(echo "${BASH_SOURCE[0]}" | md5sum | cut -d' ' -f1 | cut -c1-8)
export SB_SESS_FILE="${TMPDIR:-/tmp}/.sb_session_$(tty | tr '/' '_')_${SCRIPT_HASH}"

# we define environment variables...
export SB_APP_SERVICE=${APP_SERVICE:-"snowblower-dev"}
export SB_USER_UID=${USER_UID:-$UID}
export SB_USER_GID=${USER_GID:-$(id -g)}
export SB_SKIP_CHECKS=${SKIP_CHECKS:-}


function __sb__bootSnowBlowerEnvironment() {
    # Only source this once.

    if [ -f "$SB_SESS_FILE" ]; then
        source "$SB_SESS_FILE"
        echoOk "Found session at" "${SB_SESS_FILE}"
        return
    fi

    echoSnow "Booting SnowBlower Session" ""
    echoOk "Creating Session File" "${SB_SESS_FILE}"

    # These are the must have varibles for the project
    export SB_SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    export SB_PROJECT_ROOT="$SB_SRC_ROOT/.snowblower"
    export SB_PROJECT_PROFILE="$SB_PROJECT_ROOT/profile"
    export SB_PROJECT_STATE="$SB_PROJECT_ROOT/state"
    export SB_PROJECT_RUNTIME="$SB_PROJECT_ROOT/runtime"
    
    # Save exports to session file
    echo "export SB_SRC_ROOT=\"$SB_SRC_ROOT\"" > "$SB_SESS_FILE"
    echo "export SB_PROJECT_ROOT=\"$SB_PROJECT_ROOT\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_PROFILE=\"$SB_PROJECT_PROFILE\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_STATE=\"$SB_PROJECT_STATE\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_RUNTIME=\"$SB_PROJECT_RUNTIME\"" >> "$SB_SESS_FILE"
    

    if ! __sb__isInsideDocker; then
        # Check if Docker is installed
        export SB_DOCKER_PATH=$(which docker 2>/dev/null)
        SB_DOCKER_STATUS=$?

        if [ $SB_DOCKER_STATUS -eq 0 ] && [ -n "$SB_DOCKER_PATH" ]; then
            # Command succeeded and returned a path                                                        
            echoOk "Docker found at:" "{$SB_DOCKER_PATH}"
            echo "export SB_DOCKER_PATH=\"$SB_DOCKER_PATH\"" >> "$SB_SESS_FILE"
        else
            echoFail "Docker is not installed or not in PATH. Please install Docker to continue."
            exit 1
        fi

        # Check if Docker Compose is available
        export SB_DOCKER_COMPOSE_PATH=$(which docker-compose 2>/dev/null)
        SB_DOCKER_COMPOSE_STATUS=$?

        # If docker-compose not found, try podman-compose
        if [ $SB_DOCKER_COMPOSE_STATUS -ne 0 ] || [ -z "$SB_DOCKER_COMPOSE_PATH" ]; then
            export SB_DOCKER_COMPOSE_PATH=$(which podman-compose 2>/dev/null)
            SB_DOCKER_COMPOSE_STATUS=$?
        fi
                                                                                                        
        if [ $SB_DOCKER_COMPOSE_STATUS -eq 0 ] && [ -n "$SB_DOCKER_COMPOSE_PATH" ]; then
            # Command succeeded and returned a path                                                        
            echoOk "Docker Compose found at:" "{$SB_DOCKER_COMPOSE_PATH}"
            echo "export SB_DOCKER_COMPOSE_PATH=\"$SB_DOCKER_COMPOSE_PATH\"" >> "$SB_SESS_FILE"
        else
            echoFail "Docker Compose is not installed or not in PATH. Please install Docker to continue."
            exit 1
        fi
    fi

    echoOk "SnowBlower directory set to" "${SB_PROJECT_ROOT}"

    # Create directories if they don't exist
    if [ ! -d "$SB_PROJECT_ROOT" ]; then
        echoOk "Creating project directory" "${SB_PROJECT_ROOT}"
        mkdir -p "$SB_PROJECT_ROOT"
    fi
    if [ ! -d "$SB_PROJECT_PROFILE" ]; then
        echoOk "Creating profile directory" "${SB_PROJECT_PROFILE}"
        mkdir -p "$SB_PROJECT_PROFILE"
    fi

    if [ ! -d "$SB_PROJECT_STATE" ]; then
        echoOk "Creating state directory" "${SB_PROJECT_STATE}"
        mkdir -p "$SB_PROJECT_STATE"
    fi

    if [ ! -d "$SB_PROJECT_RUNTIME" ]; then
        echoOk "Creating runtime directory" "${SB_PROJECT_RUNTIME}"
        mkdir -p "$SB_PROJECT_RUNTIME"
    fi

    # the below two function are added via a seperate package in files.nix.
    # But we need to boot it here so we can be sure all directories are created.
    __sb__createDirectories
    __sb__createTouchFiles

    # Check if we are running in a Nix Shell
    export SB_NIX_PATH=$(which nix 2>/dev/null)
    SB_NIX_STATUS=$?
                                                                                                    
    if [ $SB_NIX_STATUS -eq 0 ] && __sb__hasNix; then
        # Command succeeded and returned a path                                                        
        echoOk "Nix found at:" "{$SB_NIX_PATH}"
        echo "export SB_NIX_PATH=\"$SB_NIX_PATH\"" >> "$SB_SESS_FILE"
    else
        echoFail "Nix command not found, some features may be limited"
    fi

    echo "export __SB_SESS_BOOTED=1" >> "$SB_SESS_FILE"
    echo
}

__sb__bootSnowBlowerEnvironment

# Split the SB_DOCKER_COMPOSE string into an array
read -ra SB_DOCKER_COMPOSE_COMMAND <<< "$SB_DOCKER_COMPOSE"
