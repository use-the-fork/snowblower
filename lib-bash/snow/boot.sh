function doSetRoot() {
	# We need to find our project root early on so downstream options can use it.
	SB_WORKSPACE_ROOT="$(findUp $SB_WORKSPACE_ROOT_FILE)"
	if [ $? -ne 0 ]; then
		_iError "Unable to locate project root. Make sure you're in a project directory with a flake.nix file"
		exit 1
	fi
	_iVerbose "Found project root at %s" $SB_WORKSPACE_ROOT
	export SB_WORKSPACE_ROOT
}

function doSetProjectHash() {
	local base_dir_name
	name=$(basename "$SB_WORKSPACE_ROOT")

	local hash
	hash=$(echo -n "$SB_WORKSPACE_ROOT" | md5sum | awk '{print $1}')

	export SB_PROJECT_HASH="${name}-r${hash}"
	_iVerbose "Set project hash as $SB_PROJECT_HASH"
}

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

	doSetupColors

	# Welcome Message
	_iSnow "SnowBlower: All flake no fluff."

	doCheckSystem
	doSetupSession
	doSetRoot
	doSetProjectHash

	# Check if our Datapath exsist in the Home Snowblower directory.
	if [ ! -d "$HOME" ]; then
		_iError "Unable to locate home folder. Please create or export one to continue."
		exit 1
	fi

	export SB_PROJECT_ROOT="$HOME/snowblower/$SB_PROJECT_HASH"
	export SB_PROJECT_ENV_FILE="$SB_PROJECT_ROOT/.project_env"

	if [ -f "$SB_PROJECT_ENV_FILE" ]; then
		_iVerbose "SnowBlower Project Directory and paths file exsist skipping init."
		source "$SB_PROJECT_ENV_FILE"

		return 0
	fi

	doInit
}

function doInit() {

	if [ ! -d "$SB_PROJECT_ROOT" ]; then
		_iOk "Initilizing Project at %s." $SB_PROJECT_ROOT

		mkdir -p "$SB_PROJECT_ROOT/profile"
		mkdir -p "$SB_PROJECT_ROOT/state"
		_iVerbose "Created profile and state directories."
	fi

	# Check if Docker is installed
	if SB_DOCKER_PATH=$(command -v docker 2>/dev/null); then
		_iOk "Docker path set to %s" "${SB_DOCKER_PATH}"
	else
		_iError "Docker is not installed or not in PATH. Please install Docker to continue."
		exit 1
	fi

	# All Checks passed we can now create the .project_env file so we dont have to do this every time.
	echo "export SB_DOCKER_PATH=\"$SB_DOCKER_PATH\"" >>"$SB_PROJECT_ENV_FILE"

	SB_PROJECT_PROFILE="$SB_PROJECT_ROOT/profile"
	echo "export SB_PROJECT_PROFILE=\"$SB_PROJECT_PROFILE\"" >>"$SB_PROJECT_ENV_FILE"

	SB_PROJECT_STATE="$SB_PROJECT_ROOT/state"
	echo "export SB_PROJECT_STATE=\"$SB_PROJECT_STATE\"" >>"$SB_PROJECT_ENV_FILE"

	if ! isSnowBlowerNixVolumeCreated; then
		_iOk "Creating snowblower-nix Docker Volume."
		$SB_DOCKER_PATH volume create snowblower-nix
	fi

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
	export SB_APP_SERVICE=${APP_SERVICE:-"tools"}
	export SB_USER_UID="$(id -u)"
	export SB_USER_GID="$(id -g)"
	export SB_WORKSPACE_ROOT_FILE=${PROJECT_ROOT_FILE:-"flake.nix"}

	if isTerminal; then
		export SB_TERM_TYPE="terminal"
	else
		export SB_TERM_TYPE="dumb"
	fi

	_iVerbose "Set project root file to %s" "${SB_WORKSPACE_ROOT_FILE}"
}
