# at this point we can setup colors etc.
doSetupColors

doCheckSystem() {
	UNAMEOUT="$(uname -s)"

	# Verify operating system is supported...
	case "${UNAMEOUT}" in
	Linux*) MACHINE=linux ;;
	Darwin*) MACHINE=mac ;;
	*) MACHINE="UNKNOWN" ;;
	esac

	if [ "$MACHINE" == "UNKNOWN" ]; then
		_iError "Unsupported operating system [$(uname -s)]." "SnowBlower supports macOS, Linux, and Windows (WSL2)." >&2
		exit 1
	fi
}

function doBoot() {

	_iVerbose "Set project root to" "${SB_SRC_ROOT}"

	# Only source this once.

	if [ -f "$SB_SESS_FILE" ]; then
		source "$SB_SESS_FILE"
		_iVerbose "Found session at %s" "${SB_SESS_FILE}"

		# Split the SB_DOCKER_COMPOSE string into an array
		read -ra SB_DOCKER_COMPOSE_COMMAND <<<"$SB_DOCKER_COMPOSE"
		return 0
	fi

	_iOk "Creating Session File %s" "${SB_SESS_FILE}"

	# These are the must have varibles for the project
	export SB_PROJECT_ROOT="$SB_SRC_ROOT/.snowblower"
	export SB_PROJECT_PROFILE="$SB_PROJECT_ROOT/profile"
	export SB_PROJECT_STATE="$SB_PROJECT_ROOT/state"
	export SB_PROJECT_RUNTIME="$SB_PROJECT_ROOT/runtime"

	# Save exports to session file
	echo "export SB_PROJECT_ROOT=\"$SB_PROJECT_ROOT\"" >>"$SB_SESS_FILE"
	echo "export SB_PROJECT_PROFILE=\"$SB_PROJECT_PROFILE\"" >>"$SB_SESS_FILE"
	echo "export SB_PROJECT_STATE=\"$SB_PROJECT_STATE\"" >>"$SB_SESS_FILE"
	echo "export SB_PROJECT_RUNTIME=\"$SB_PROJECT_RUNTIME\"" >>"$SB_SESS_FILE"

	# Check if Docker is installed
	if SB_DOCKER_PATH=$(command -v docker 2>/dev/null) && [ -n "$SB_DOCKER_PATH" ]; then
		export SB_DOCKER_PATH
		_iOk "Docker path set to %s" "${SB_DOCKER_PATH}"
		echo "export SB_DOCKER_PATH=\"$SB_DOCKER_PATH\"" >>"$SB_SESS_FILE"
	else
		doDestroySession
		_iError "Docker is not installed or not in PATH. Please install Docker to continue."
		exit 1
	fi

	# Check if Docker Compose is available
	if SB_DOCKER_COMPOSE_PATH=$(command -v docker-compose 2>/dev/null) && [ -n "$SB_DOCKER_COMPOSE_PATH" ]; then
		export SB_DOCKER_COMPOSE_PATH
		_iOk "Docker Compose path set to %s" "${SB_DOCKER_COMPOSE_PATH}"
		echo "export SB_DOCKER_COMPOSE_PATH=\"$SB_DOCKER_COMPOSE_PATH\"" >>"$SB_SESS_FILE"
	elif SB_DOCKER_COMPOSE_PATH=$(command -v podman-compose 2>/dev/null) && [ -n "$SB_DOCKER_COMPOSE_PATH" ]; then
		export SB_DOCKER_COMPOSE_PATH
		_iOk "Docker Compose path set to %s" "${SB_DOCKER_COMPOSE_PATH}"
		echo "export SB_DOCKER_COMPOSE_PATH=\"$SB_DOCKER_COMPOSE_PATH\"" >>"$SB_SESS_FILE"
	else
		doDestroySession
		_iError "Docker Compose is not installed or not in PATH. Please install Docker to continue."
		exit 1
	fi

	_iNote "SnowBlower root directory set to" "${SB_SRC_ROOT}"

	# Create directories if they don't exist
	if [ ! -d "$SB_PROJECT_ROOT" ]; then
		_iVerbose "Creating project directory" "${SB_PROJECT_ROOT}"
		mkdir -p "$SB_PROJECT_ROOT"
	fi
	if [ ! -d "$SB_PROJECT_PROFILE" ]; then
		_iVerbose "Creating profile directory" "${SB_PROJECT_PROFILE}"
		mkdir -p "$SB_PROJECT_PROFILE"
	fi

	if [ ! -d "$SB_PROJECT_STATE" ]; then
		_iVerbose "Creating state directory" "${SB_PROJECT_STATE}"
		mkdir -p "$SB_PROJECT_STATE"
	fi

	if [ ! -d "$SB_PROJECT_RUNTIME" ]; then
		_iVerbose "Creating runtime directory" "${SB_PROJECT_RUNTIME}"
		mkdir -p "$SB_PROJECT_RUNTIME"
	fi

	#Symlink SnowBlower to the profile
	ln -sf "${SB_SRC_ROOT}/snow" "${SB_PROJECT_PROFILE}/snow"

	# the below two function are added via a seperate package in files.nix.
	# But we need to boot it here so we can be sure all directories are created.
	doCreateDirectories
	doCreateTouchFiles

	return 0

}

function doSetupSession() {

	# Source the ".env" file so environment variables are available...
	# shellcheck source=/dev/null
	if [ -n "${APP_ENV+x}" ] && [ -n "$APP_ENV" ] && [ -f ./.env."$APP_ENV" ]; then
		source ./.env."$APP_ENV"
		_iNote "Found and sourced %s" ".env.{$APP_ENV}"
	elif [ -f ./.env ]; then
		source ./.env
		_iNote "Found and sourced %s" ".env"
	fi

	# Global constants that are used in many parts of the script
	export SB_APP_SERVICE=${APP_SERVICE:-"snowblower-dev"}
	export SB_USER_UID=${USER_UID:-$UID}
	export SB_USER_GID=${USER_GID:-$(id -g)}
	export SB_SKIP_CHECKS=${SKIP_CHECKS:-}
	export SB_PROJECT_ROOT_FILE=${PROJECT_ROOT_FILE:-"flake.nix"}

	# Create a session file in tmp dir. this allows us to do the "heavy" lifiting for the snow command one time.
	export SB_SESS_FILE="${SB_SRC_ROOT:-/tmp}/.snowblower/.sb_session"

	_iVerbose "Set project root to" "${SB_SRC_ROOT}"
}

function doSetRoot() {
	# We need to find our project root early on so downstream options can use it.
	SB_SRC_ROOT="$(findUp "flake.nix")"
	if [ $? -ne 0 ]; then
		_iError "Unable to locate project root. Make sure you're in a project directory with a flake.nix file"
		exit 1
	fi
	export SB_SRC_ROOT
}
