# From: https://github.com/kigster/bashmatic/blob/main/lib/output.sh#L94

export LEFT_PREFIX="    "

function cursorSave() {
	isTerminal && printf "\e[s"
}

function cursorRestore() {
	isTerminal && printf "\e[u"
}

function cursorHide() {
	isTerminal && printf "\033[?25l"
}

function cursorShow() {
	isTerminal && printf "\033[?25h"
}

function cursorRightBy() {
	isTerminal && printf "\e[${1:-"1"}C"
}

function cursorLeftBy() {
	isTerminal && printf "\e[${1:-"1"}D"
}

function cursorUpBy() {
	isTerminal && printf "\e[${1:-"1"}A"
}

function cursorDownBy() {
	isTerminal && printf "\e[${1:-"1"}B"
}

function cursorUp() {
	cursorUpBy "$@"
}

function cursorDown() {
	cursorDownBy "$@"
}

function _inlineFlake() {
	printf "${CYAN} ❆ ${NC}"
}

function _inlineHeart() {
	printf "${RED} ❤ ${NC}"
}

function _inlineCheck() {
	printf "${GREEN} ✔︎ ${NC}"
}

function _inlineNotOk() {
	inlineError
}

function _inlineCross() {
	printf "${RED} ✘ ${NC}"
}

function _inlineWarning() {
	printf "${YELLOW} ✱ ${NC}"
}

function _inlineNote() {
	printf "      ${NC}"
}

function _iBreak() {
	echo "${NC}"
}

function _iClear() {
	printf "\033[0J"
}

function _i() {
	local msgid="$1"
	shift

	printf "${LEFT_PREFIX}${msgid}\n" "$@"
}

function _iSnow() {
	_i "$@"
	cursorUp 1
	_inlineFlake
	echo "${NC}"
}

function _iHeart() {
	_i "$@"
	cursorUp 1
	_inlineHeart
	echo "${NC}"
}

function _iOk() {
	_i "$@"
	cursorUp 1
	_inlineCheck
	echo "${NC}"
}

function _iNotOk() {
	_i "$@"
	cursorUp 1
	_inlineCross
	echo "${NC}"
}

function _iError() {
	echo -n "${RED}"
	_i "$@"
	echo -n "${NC}"
}

function _iFail() {
	_iError "$@"
}

function _iWarn() {
	echo -n "${YELLOW}"
	_i "$@"
	echo -n "${NC}"
}

function _iNote() {
	echo -n "${BLUE}"
	_i "$@"
	echo -n "${NC}"
}

function _iVerbose() {
	if [[ -v VERBOSE ]]; then
		_i "$@"
	fi
}

function _iWithSpinner() {
	local message="$1"
	shift

	local command="$@"

	local spinner="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
	local temp_file=$(mktemp)

   # Cleanup function for trap
    function cleanup() {
        cursorShow
        rm -f "$temp_file"
        kill $cmd_pid 2>/dev/null || true
    }

	# Set trap to cleanup on exit/interrupt
    trap cleanup EXIT INT TERM

	# Start command in background
	eval "$command" >"$temp_file" 2>&1 &
	local cmd_pid=$!

	# Save cursor position and hide it
	cursorSave
	cursorHide

	# Show spinner while command runs
	local i=0
	while kill -0 $cmd_pid 2>/dev/null; do

		# Move up to spinner line and update it
		printf " ${NC}${CYAN}%s  ${NC}${WHITE}%s${NC}" "${spinner:i:1}" "$message"

		# Show last 4 lines of output if file exists and has content
		if [[ -s $temp_file ]]; then
			local last_output=$(tail -n 5 "$temp_file" 2>/dev/null)
			if [[ -n $last_output ]]; then
				printf "\n"
				echo "$last_output" | sed 's/^/    /'
			fi
		fi

		# Restore cursor position
		cursorRestore

		i=$(((i + 1) % ${#spinner}))
		sleep 0.1
	done

	cursorShow
	cursorRestore
	_iClear
	

	# Wait for command to finish and get exit code
	wait $cmd_pid
	local exit_code=$?

	# Clear the spinner line and show final status
	if [ $exit_code -eq 0 ]; then
		_iOk "$message"
	else
		_iNotOk "$message"
		# TODO: Make this print better?
		cat "$temp_file"
	fi

	rm -f "$temp_file"
	return $exit_code
}

function _iCommandSection() {
	local command_name="$1"
	local display_name="$2"
	shift 2
	local options=("$@")

	echo "${YELLOW}${display_name} Commands:${NC}"
	# First pass: calculate the maximum width of command part
	local max_width=0
	local commands=()
	local descriptions=()

	for option in "${options[@]}"; do
		if [[ $option == *"|"* ]]; then
			IFS='|' read -r cmd desc <<<"$option"
			if [[ -n $command_name ]]; then
				local cmd_text="snow -- ${command_name} ${cmd}"
			else
				local cmd_text="snow ${cmd}"
			fi
			commands+=("$cmd_text")
			descriptions+=("$desc")
		else
			if [[ -n $command_name ]]; then
				local cmd_text="snow -- ${command_name} ..."
			else
				local cmd_text="snow ..."
			fi
			commands+=("$cmd_text")
			descriptions+=("Run a ${display_name} command")
		fi

		# Calculate width without color codes
		local width=${#cmd_text}
		if ((width > max_width)); then
			max_width=$width
		fi
	done

	# Second pass: print with aligned descriptions
	for i in "${!commands[@]}"; do
		local cmd_text="${commands[i]}"
		local desc="${descriptions[i]}"
		local padding_needed=$((35 - ${#cmd_text}))
		local padding=$(printf "%*s" $padding_needed "")

		echo "  ${GREEN}${cmd_text}${NC}${padding}${desc}"
	done

	echo
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
