# From: https://github.com/kigster/bashmatic/blob/main/lib/output.sh#L94

# TODO: Add IsTerminal to commands
#  Note that some function names end with : – this indicates that the function outputs a new-line in the end. 

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

