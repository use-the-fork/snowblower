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
	_iError "$@" >&2
	exit 1
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
