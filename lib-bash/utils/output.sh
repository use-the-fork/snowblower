# From: https://github.com/kigster/bashmatic/blob/main/lib/output.sh#L94

# TODO: Add IsTerminal to commands

export LEFT_PREFIX="    "

function cursorRightBy() {
	#   output.is-terminal && printf "\e[${1}C"
	printf "\e[${1:-"1"}C"
}

function cursorLeftBy() {
	#   output.is-terminal && printf "\e[${1}D"
	printf "\e[${1:-"1"}D"
}

function cursorUpBy() {
	printf "\e[${1:-"1"}A"
}

function cursorDownBy() {
	#   output.is-terminal && printf "\e[${1}B"
	printf "\e[${1:-"1"}B"
}

function cursorUp() {
	cursorUpBy "$@"
}

function cursorDown() {
	cursorDownBy "$@"
}

function _inlineFlake() {
	cursorUp 1
	printf " ❄️ ${NC}"
}

function _inlineCloud() {
	cursorUp 1
	printf " 💨 ${NC}"
}

function _inlineCheck() {
	cursorUp 1
	printf "${GREEN} ✔︎ ${NC}"
}

function _inlineNotOk() {
	inlineError
}

function _inlineCross() {
	cursorUp 1
	printf "${RED} ✘ ${NC}"
}

function _inlineWarning() {
	cursorUp 1
	printf "${YELLOW} ✱ ${NC}"
}

function _inlineNote() {
	cursorUp 1
	printf "      ${NC}"
}

function _iBreak() {
	echo "${NC}"
}

function _i() {
	local msgid="$1"
	shift

	printf "${LEFT_PREFIX}${msgid}\n" "$@"
}

function _iSnow() {
	_i "$@"
	_inlineFlake
	echo "${NC}"
}

function _iCloud() {
	_i "$@"
	_inlineFlake
	echo "${NC}"
}

function _iOk() {
	_i "$@"
	_inlineCheck
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

function _iCommandSection() {
	local command_name="$1"
	local display_name="$2"
	shift 2
	local options=("$@")

	echo "${YELLOW}${display_name} Commands:${NC}"
	# snow docker restart
	# First pass: calculate the maximum width of command part
	local max_width=0
	local commands=()
	local descriptions=()

	for option in "${options[@]}"; do
		if [[ $option == *"|"* ]]; then
			IFS='|' read -r cmd desc <<<"$option"
			local cmd_text="snow -- ${command_name} ${cmd}"
			commands+=("$cmd_text")
			descriptions+=("$desc")
		else
			local cmd_text="snow -- ${command_name} ..."
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
		local padding_needed=$((max_width - ${#cmd_text} + 10))
		local padding=$(printf "%*s" $padding_needed "")

		echo "  ${GREEN}${cmd_text}${NC}${padding}${desc}"
	done

	echo
}
