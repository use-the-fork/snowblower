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

# These are the must have varibles for the project
export SB_FLAKE_ROOT=$(findUp 'flake.nix')
export SB_PROJECT_ROOT="$SB_FLAKE_ROOT/.snowblower"
export PROJECT_PROFILE="$SB_PROJECT_ROOT/profile"
export PROJECT_STATE="$SB_PROJECT_ROOT/state"
export PROJECT_RUNTIME="$SB_PROJECT_ROOT/runtime"

# Create directories if they don't exist
if [ ! -d "$SB_PROJECT_ROOT" ]; then
    noteEcho "Creating project directory: $SB_PROJECT_ROOT"
    mkdir -p "$SB_PROJECT_ROOT"
fi
if [ ! -d "$PROJECT_PROFILE" ]; then
    noteEcho "Creating profile directory: $PROJECT_PROFILE"
    mkdir -p "$PROJECT_PROFILE"
fi

if [ ! -d "$PROJECT_STATE" ]; then
    noteEcho "Creating state directory: $PROJECT_STATE"
    mkdir -p "$PROJECT_STATE"
fi

if [ ! -d "$PROJECT_RUNTIME" ]; then
    noteEcho "Creating runtime directory: $PROJECT_RUNTIME"
    mkdir -p "$PROJECT_RUNTIME"
fi


# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    errorEcho "Docker is not installed or not in PATH. Please install Docker to continue."
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    errorEcho "Docker Compose is not installed or not in PATH. Please install Docker Compose to continue."
    exit 1
fi

# Define Docker Compose command prefix...
if docker compose &> /dev/null; then
    DOCKER_COMPOSE=(docker compose)
else
    DOCKER_COMPOSE=(docker-compose)
fi
