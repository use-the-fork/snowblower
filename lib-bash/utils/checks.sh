# Various Check functions

function isInsideDocker() {
	test -f /.dockerenv
}

function hasNix() {
	if [ -n "$SB_NIX_PATH" ]; then
		return 0
	else
		return 1
	fi
}

function isInsideSnowblowerShell() {
	if [ -n "$SB_IN_SHELL" ]; then
		return 0
	else
		return 1
	fi
}

function shouldExit() {
	local -r exit_code="${1}"
	shift
	local -r expected="${1}"
	shift
	if [ "$exit_code" != "${expected:-0}" ]; then
		exit "${exit_code}"
	fi
}
