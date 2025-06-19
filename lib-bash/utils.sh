#!/usr/bin/env bash
###############################################################################################
#
#  SnowBlower: All Flake No Fluff
#  https://github.com/use-the-fork/snowblower
#

export TEXTDOMAINDIR=@OUT@/share/locale

set -e
set -o pipefail

function setVerboseArg() {
    if [[ -v VERBOSE ]]; then
        export VERBOSE_ARG="--verbose"
    else
        export VERBOSE_ARG=""
    fi
}


# Credits to https://github.com/nix-community/home-manager/blob/master/lib/bash/home-manager.sh
# The setup respects the `NO_COLOR` environment variable.
function setupColors() {
  BOLD=""
  DIM=""
  UNDERLINE=""
  BLINK=""
  REVERSE=""
  NC=""
  BLACK=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
  WHITE=""

  # Enable colors for terminals, and allow opting out.
  if [[ ! -v NO_COLOR && -t 1 ]]; then
    # See if it supports colors.
    local ncolors
    ncolors=$(tput colors 2>/dev/null || echo 0)

    if [[ -n $ncolors && $ncolors -ge 8 ]]; then
      # Text attributes
      BOLD="$(tput bold)"
      DIM="$(tput dim)"
      UNDERLINE="$(tput smul)"
      BLINK="$(tput blink)"
      REVERSE="$(tput rev)"
      NC="$(tput sgr0)" # No Color

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

function executeWithSpinner() {
  local message="$1"
  local command="$2"
  local detail="${3:-}"

  local spinner="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
  local temp_file=$(mktemp)

  # Start command in background
  eval "$command" >"$temp_file" 2>&1 &
  local cmd_pid=$!

  # Show spinner while command runs
  local i=0
  while kill -0 $cmd_pid 2>/dev/null; do
    printf "\r${WHITE}[ ${BLUE}%s${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}" \
      "${spinner:i:1}" "$message" "$detail"
    i=$(((i + 1) % ${#spinner}))
    sleep 0.1
  done

  # Wait for command to finish and get exit code
  wait $cmd_pid
  local exit_code=$?

  # Show final status
  if [ $exit_code -eq 0 ]; then
    echoOk "$message" "$detail"
  else
    echoFail "$message" "$detail"
    cat "$temp_file"
  fi

  rm -f "$temp_file"
  return $exit_code
}

function echoSnow() {
  local message="${1:-}"
  printf "${WHITE}[ ❄️💨 ]  ${BOLD}${WHITE}%s${NC}\n" "${message}"
}
function echoOk() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "${WHITE}[ ${GREEN} OK ${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoWarn() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "${WHITE}[ ${YELLOW}WARN${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoFail() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "${WHITE}[ ${RED}FAIL${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoInfo() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "${WHITE}[ ${BLUE}INFO${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoBlank() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "          ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}


function echoHasVerbose() {
  local message="${1:-}"
  local detail="${2:-}"

    if [[ "$VERBOSE" != "no" ]] || [ -z "$VERBOSE" ]; then
    printf "${WHITE}[ ${YELLOW}ECHO${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
  fi
}
function echoDebug() {
  local message="${1:-}"
  local detail="${2:-}"

  if [ -n "${DEBUG:-}" ]; then
    printf "${WHITE}[ ${YELLOW}DEBUG${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
  fi
}


# #################################



function _i() {
    local msgid="$1"
    shift

    # shellcheck disable=2059
    printf "$msgid\n" "$@"
}

function _ip() {
    local msgid="$1"
    local msgidPlural="$2"
    local count="$3"
    shift 3

    # shellcheck disable=2059
    if [ "$count" -eq 1 ]; then
        printf "$msgid\n" "$@"
    else
        printf "$msgidPlural\n" "$@"
    fi
}

function _iError() {
    echo -n "${RED}"
    _i "$@"
    echo -n "${NC}"
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

# Runs the given command on live run, otherwise prints the command to standard
# output.
#
# If given the command line option `--quiet`, then the command's standard output
# is sent to `/dev/null` on a live run.
#
# If given the command line option `--silence`, then the command's standard and
# error output is sent to `/dev/null` on a live run.
#
# The `--silence` and `--quiet` flags are mutually exclusive.
function run() {
    if [[ $1 == '--quiet' ]]; then
        local quiet=1
        shift
    elif [[ $1 == '--silence' ]]; then
        local silence=1
        shift
    fi

    if [[ -v DRY_RUN ]] ; then
        echo "$@"
    elif [[ -v quiet ]] ; then
        "$@" > /dev/null
    elif [[ -v silence ]] ; then
        "$@" > /dev/null 2>&1
    else
        "$@"
    fi
}




# #################################




# Credits: https://github.com/srid/flake-root/blob/master/flake-module.nix
# This function is used to find the flake root and set it as a env varible.
findUp() {
  ancestors=()
  while true; do
  if [[ -f $1 ]]; then
      echo "$PWD"
      exit 0
  fi
  ancestors+=("$PWD")
  if [[ $PWD == / ]] || [[ $PWD == // ]]; then
      echo "Unable to locate ${1}"
      exit 1
  fi
  cd ..
  done
}

function createTouchFile() {
  local filePath="$1"
  # Evaluate the path with variables
  filePath=$(eval echo "$filePath")

  # Check if the path is not already within the project root
  if [[ $filePath != "$SB_PROJECT_ROOT"* ]]; then
    filePath="${SB_PROJECT_ROOT}/${filePath}"
  fi

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$filePath")"

  # Touch the file to create it empty
  touch "$filePath"
  echoBlank "Created touch file" "$filePath"
}

function createDirectory() {
  local dirPath="$1"
  # Evaluate the path with variables
  dirPath=$(eval echo "$dirPath")

  # Check if the path is not already within the project root
  if [[ $dirPath != "$SB_PROJECT_ROOT"* ]]; then
    dirPath="${SB_PROJECT_ROOT}/${dirPath}"
  fi

  mkdir -p "$dirPath"
  echoBlank "Created directory" "$dirPath"
}

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
