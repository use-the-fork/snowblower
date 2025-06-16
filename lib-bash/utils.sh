#!/usr/bin/env bash

set -e
set -o pipefail

# Credits to https://github.com/nix-community/home-manager/blob/master/lib/bash/home-manager.sh

# Sets up colors suitable for the `errorEcho`, `warnEcho`, and `noteEcho`
# functions.
#
# The check for terminal output and color support is heavily inspired by
# https://unix.stackexchange.com/a/10065.
#
# The setup respects the `NO_COLOR` environment variable.
function setupColors() {
    normalColor=""
    errorColor=""
    warnColor=""
    noteColor=""

    # Enable colors for terminals, and allow opting out.
    if [[ ! -v NO_COLOR && -t 1 ]]; then
        # See if it supports colors.
        local ncolors
        ncolors=$(tput colors 2> /dev/null || echo 0)

        if [[ -n "$ncolors" && "$ncolors" -ge 8 ]]; then
            normalColor="$(tput sgr0)"
            errorColor="$(tput bold)$(tput setaf 1)"
            warnColor="$(tput setaf 3)"
            noteColor="$(tput bold)$(tput setaf 6)"

            # Text attributes
            BOLD="$(tput bold)"
            DIM="$(tput dim)"
            # UNDERLINE="$(tput smul)"
            # BLINK="$(tput blink)"
            # REVERSE="$(tput rev)"
            NC="$(tput sgr0)"  # No Color

            # Regular colors
            BLACK="$(tput setaf 0)"
            RED="$(tput setaf 1)"
            GREEN="$(tput setaf 2)"
            YELLOW="$(tput setaf 3)"
            BLUE="$(tput setaf 4)"
            MAGENTA="$(tput setaf 5)"
            CYAN="$(tput setaf 6)"
            WHITE="$(tput setaf 7)"
        fi
    fi
}




setupColors

function statusEcho() {
    local status="${1:-}"
    local message="$2"
    local detail="${3:-}"
    
    if [ "$status" == "OK" ]; then
        echo "${WHITE}[ ${GREEN} OK ${WHITE} ]  ${NC}${DIM}${message}${NC} ${WHITE}${detail}${NC}"
    elif [ "$status" == "FAIL" ]; then
        echo "${WHITE}[ ${RED}FAIL${WHITE} ]  ${NC}${DIM}${message}${NC} ${WHITE}${detail}${NC}"
    elif [ "$status" == "WARN" ]; then
        echo "${WHITE}[ ${YELLOW}WARN${WHITE} ]  ${NC}${DIM}${message}${NC} ${WHITE}${detail}${NC}"
    elif [ "$status" == "INFO" ]; then
        echo "${WHITE}[ ${BLUE}INFO${WHITE} ]  ${NC}${DIM}${message}${NC} ${WHITE}${detail}${NC}"
    else
        echo "          ${NC}${DIM}${message}${NC} ${WHITE}${detail}${NC}"
    fi
}

function errorEcho() {
    echo "${errorColor}$*${normalColor}"
}

function warnEcho() {
    echo "${warnColor}$*${normalColor}"
}

function noteEcho() {
    echo "${noteColor}$*${normalColor}"
}

function verboseEcho() {
    if [[ -v VERBOSE ]]; then
        echo "$*"
    fi
}

function _i() {
    local msgid="$1"
    shift

    # shellcheck disable=2059
    printf "$("$msgid")\n" "$@"
}

function _ip() {
    local msgid="$1"
    local msgidPlural="$2"
    local count="$3"
    shift 3

    # shellcheck disable=2059
    printf "$("$msgid" "$msgidPlural" "$count")\n" "$@"
}

function _iError() {
    echo -n "${errorColor}"
    _i "$@"
    echo -n "${normalColor}"
}

function _iWarn() {
    echo -n "${warnColor}"
    _i "$@"
    echo -n "${normalColor}"
}

function _iNote() {
    echo -n "${noteColor}"
    _i "$@"
    echo -n "${normalColor}"
}

function _iVerbose() {
    if [[ -v VERBOSE ]]; then
        _i "$@"
    fi
}

# Credits: https://github.com/srid/flake-root/blob/master/flake-module.nix
# This function is used to find the flake root and set it as a env varible.
__sb__findUp() {
    ancestors=()
    while true; do
    if [[ -f $1 ]]; then
        echo "$PWD"
        exit 0
    fi
    ancestors+=("$PWD")
    if [[ $PWD == / ]] || [[ $PWD == // ]]; then
        echo "ERROR: Unable to locate the ${config.flake-root.projectRootFile} in any of: ''${ancestors[*]@Q}" >&2
        exit 1
    fi
    cd ..
    done
}

function __sb__createDirectory() {
    local dirPath="$1"
    # Evaluate the path with variables
    dirPath=$(eval echo "$dirPath")

    # Check if the path is not already within the project root
    if [[ "$dirPath" != "$SB_PROJECT_ROOT"* ]]; then
        dirPath="${SB_PROJECT_ROOT}/${dirPath}"
    fi

    mkdir -p "$dirPath"
    statusEcho "" "Created directory" "$dirPath"
}

# Various Check functions

function __sb__isInsideDocker(){
    test -f /.dockerenv
}

function __sb__hasNix(){
    if [ -n "$SB_NIX_PATH" ]; then
        return 0
    else
        return 1
    fi
}