# Function that outputs SnowBlower is not running...
function snowblower_is_not_running {
    echo "${BOLD}SnowBlower is not running.${NC}" >&2
    echo "" >&2
    echo "${BOLD}You may start docker using the following commands:${NC} './snow up'" >&2

    exit 1
}

# Define Docker Compose command prefix...
if docker compose &> /dev/null; then
    DOCKER_COMPOSE=(docker compose)
else
    DOCKER_COMPOSE=(docker-compose)
fi

# ARGS=()
if [ "$1" == "switch" ]; then
    nix run .#snowblower-files
fi

# Build the Docker containers
if [ "$1" == "build" ]; then
    echo "1234";
    "${DOCKER_COMPOSE[@]}" build "$@"
    exit
fi
