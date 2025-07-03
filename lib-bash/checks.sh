function isSnowBlowerUp {
	if ! isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower is not running."
		_iNote "You must first run 'snow up'."
		exit 1
	fi
}

function isSnowBlowerDockerContainerUp {
	# Check if snowblower-dev service container exists and is running
	[ -n "$($SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" ps -q "$SB_APP_SERVICE" 2>/dev/null)" ]
}

function isSnowBlowerNixVolumeCreated {
	[ -n "$($SB_DOCKER_PATH volume inspect snowblower-nix 2>/dev/null)" ]
}

# Function that checks
function doRunChecks {
	if [ -z "$SB_SKIP_CHECKS" ]; then
		# Ensure that SnowBlower is running...
		if ! isSnowBlowerDockerContainerUp; then
			_iFail "${BOLD}SnowBlower is not running.${NC}" >&2
			_iNote "Run 'snow up' to start SnowBlower."
			exit 1
		fi

		# Determine if SnowBlower is currently up...
		# if $SB_DOCKER_PATH compose -f "$SB_WORKSPACE_ROOT/docker-compose.yml" ps -q "$SB_APP_SERVICE" 2>&1 | grep 'Exit\|exited'; then
		# 	_iWarn "${BOLD}Shutting down old SnowBlower processes...${NC}" >&2
		# 	$SB_DOCKER_PATH down >/dev/null 2>&1
		# 	isNotRunning
		# elif [ -z "$($SB_DOCKER_PATH ps -q "$SB_APP_SERVICE")" ]; then
		# 	isNotRunning
		# fi
	fi
}
