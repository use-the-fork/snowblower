# Various Check functions

function isInsideDocker() {
	test -f /.dockerenv
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

function isTerminal() {
	isTty || isRedirect || isPipe || isSsh
}

function isTty() {
	[[ -t 1 ]]
}

function isRedirect() {
	[[ ! -t 1 && ! -p /dev/stdout ]]
}

function isPipe() {
	[[ -p /dev/stdout ]]
}

function isSsh() {
	[[ -n ${SSH_CLIENT} || -n ${SSH_CONNECTION} ]]
}
