UNAMEOUT="$(uname -s)"

# Verify operating system is supported...
case "${UNAMEOUT}" in
    Linux*)             MACHINE=linux;;
    Darwin*)            MACHINE=mac;;
    *)                  MACHINE="UNKNOWN"
esac

if [ "$MACHINE" == "UNKNOWN" ]; then
    echo "Unsupported operating system [$(uname -s)]. SnowBlower supports macOS, Linux, and Windows (WSL2)." >&2
    exit 1
fi


# Source the ".env" file so environment variables are available...
# shellcheck source=/dev/null
if [ -n "${APP_ENV+x}" ] && [ -n "$APP_ENV" ] && [ -f ./.env."$APP_ENV" ]; then
  source ./.env."$APP_ENV";
elif [ -f ./.env ]; then
  source ./.env;
fi

# Create a session file in tmp dir. this allows us to do the "heavy" lifiting for the snow command one time.
export SB_SESS_FILE="${TMPDIR:-/tmp}/.sb_session_$(tty | tr '/' '_')"


function __sb__bootSnowBlowerEnvironment() {
    # Only source this once.

    if [ -f "$SB_SESS_FILE" ]; then
        source "$SB_SESS_FILE"
        warnEcho ${SB_SESS_FILE}
        return
    fi

    statusEcho "" "Booting SnowBlower Session" ""
    statusEcho "OK" "Creating Session File" "${SB_SESS_FILE}"


    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        statusEcho "FAIL" "Docker is not installed or not in PATH. Please install Docker to continue."
        exit 1
    fi

    # Check if Docker Compose is available
    if ! docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
        statusEcho "FAIL" "Docker Compose is not installed or not in PATH. Please install Docker Compose to continue."
        exit 1
    fi

    # These are the must have varibles for the project
    export SB_FLAKE_ROOT=$(__sb__findUp 'flake.nix')
    export SB_PROJECT_ROOT="$SB_FLAKE_ROOT/.snowblower"
    export SB_PROJECT_PROFILE="$SB_PROJECT_ROOT/profile"
    export SB_PROJECT_STATE="$SB_PROJECT_ROOT/state"
    export SB_PROJECT_RUNTIME="$SB_PROJECT_ROOT/runtime"
    
    # Save exports to session file
    echo "export SB_FLAKE_ROOT=\"$SB_FLAKE_ROOT\"" > "$SB_SESS_FILE"
    echo "export SB_PROJECT_ROOT=\"$SB_PROJECT_ROOT\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_PROFILE=\"$SB_PROJECT_PROFILE\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_STATE=\"$SB_PROJECT_STATE\"" >> "$SB_SESS_FILE"
    echo "export SB_PROJECT_RUNTIME=\"$SB_PROJECT_RUNTIME\"" >> "$SB_SESS_FILE"
    
    statusEcho "OK" "SnowBlower directory set to" "${SB_PROJECT_ROOT}"

    # Create directories if they don't exist
    if [ ! -d "$SB_PROJECT_ROOT" ]; then
        statusEcho "OK" "Creating project directory" "${SB_PROJECT_ROOT}"
        mkdir -p "$SB_PROJECT_ROOT"
    fi
    if [ ! -d "$SB_PROJECT_PROFILE" ]; then
        statusEcho "OK" "Creating profile directory" "${SB_PROJECT_PROFILE}"
        mkdir -p "$SB_PROJECT_PROFILE"
    fi

    if [ ! -d "$SB_PROJECT_STATE" ]; then
        statusEcho "OK" "Creating state directory" "${SB_PROJECT_STATE}"
        mkdir -p "$SB_PROJECT_STATE"
    fi

    if [ ! -d "$SB_PROJECT_RUNTIME" ]; then
        statusEcho "OK" "Creating runtime directory" "${SB_PROJECT_RUNTIME}"
        mkdir -p "$SB_PROJECT_RUNTIME"
    fi

    # this function is added via a seperate package in files.nix.
    # But we need to boot it here so we can be sure all directories are created.
    __sb__createDirectories

    # Define Docker Compose command prefix
    if docker compose &> /dev/null; then
        export SB_DOCKER_COMPOSE="docker compose"
    else
        export SB_DOCKER_COMPOSE="docker-compose"
    fi

    echo "export SB_DOCKER_COMPOSE=\"$SB_DOCKER_COMPOSE\"" >> "$SB_SESS_FILE"
    statusEcho "OK" "Docker Compose Command set as" "${SB_DOCKER_COMPOSE}"

    # Check if we are running in a Nix Shell
    if [ -n "${SB_SESS_IS_NIX_SHELL+x}" ]; then
        statusEcho "OK" "Nix command found and available"
    else
        statusEcho "FAIL" "Nix command not found, some features may be limited"
    fi

    echo "export __SB_SESS_BOOTED=1" >> "$SB_SESS_FILE"

    echo
}

# Finally we define environment variables...
export SB_APP_SERVICE=${APP_SERVICE:-"snowblower-dev"}
export SB_USER_UID=${USER_UID:-$UID}
export SB_USER_GID=${USER_GID:-$(id -g)}
export SB_SKIP_CHECKS=${SKIP_CHECKS:-}
export SB_SESS_IS_NIX_SHELL=${IS_NIX_SHELL:-}

__sb__bootSnowBlowerEnvironment

# Split the SB_DOCKER_COMPOSE string into an array
read -ra SB_DOCKER_COMPOSE_COMMAND <<< "$SB_DOCKER_COMPOSE"
