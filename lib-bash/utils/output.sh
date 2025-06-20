# From: https://github.com/kigster/bashmatic/blob/main/lib/output.sh#L94

# TODO: Add IsTerminal to commands
#  Note that some function names end with : – this indicates that the function outputs a new-line in the end. 

export LEFT_PREFIX="       "

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

function _inlineOk() {
  cursorUp 1
  printf "${GREEN} ✔︎    ${NC}"
}

function _inlineNotOk() {
  inlineError
}

function _inlineError() {
  cursorUp 1
  printf "${RED} ✘    ${NC}"
}

function _inlineWarning() {
  cursorUp 1
  printf "${YELLOW} ✱    ${NC}"
}

function _inlineNote() {
  cursorUp 1
  printf "      ${NC}"
}

function _iBreak() {
    echo "${NC}"
}


function _iSnowStart() {
  printf "${BLUE} ❄️    ${WHITE}$1${NC}\n"
}
function _iSnowEnd() {
  printf "${BLUE} 💨    ${WHITE}$1${NC}\n"
}

function _i() {
    printf -- "${LEFT_PREFIX}${NC}${DIM}$*${NC}\n"
}

function _iOk() {
    _i "$@"
    _inlineOk
    echo "${NC}"
}

function _iError() {
    _i "$@"
    _inlineError
    _iBreak
}

function _iFail() {
    _iError "$@"
}

function _iWarn() {
    _i "$@"
    _inlineWarning
    _iBreak
}

function _iNote() {
    _i "$@"
    _inlineNote
    _iBreak
}

function _iVerbose() {
    if [[ -v VERBOSE ]]; then
        _i "$@"
    fi
}