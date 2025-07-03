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

function checkLastCommand() {
	local -r exit_code=$?
	local -r success_message="${1}"
	local -r fail_message="${2}"
	local -r should_restore="${3}"

	if [ $exit_code -eq 0 ]; then
		if [ -n "$should_restore" ]; then
			cursorRestore
			_iClear
		fi

		if [ -n "$success_message" ]; then
			_iOk "$success_message"
		fi
	else
		if [ -n "$fail_message" ]; then
			_iError "$fail_message"
		fi
		exit $exit_code
	fi
}
