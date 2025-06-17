#!/usr/bin/env bash
###############################################################################################
#
#  SnowBlower: All Flake No Fluff
#  https://github.com/use-the-fork/snowblower
#

set -e
set -o pipefail

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
  printf "${WHITE}[ ${GREEN} ❄️💨 ${WHITE} ]  ${BOLD}${WHITE}%s${NC}\n" "${message}"
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
function statusInfo() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "${WHITE}[ ${BLUE}INFO${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoBlank() {
  local message="${1:-}"
  local detail="${2:-}"
  printf "          ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
}
function echoDebug() {
  local message="${1:-}"
  local detail="${2:-}"

  if [ -n "${DEBUG:-}" ]; then
    printf "${WHITE}[ ${YELLOW}DEBUG${WHITE} ]  ${NC}${DIM}%s${NC} ${WHITE}%s${NC}\n" "${message}" "${detail}"
  fi
}

function __sb__createTouchFile() {
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

function __sb__createDirectory() {
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

function __sb__isInsideDocker() {
  test -f /.dockerenv
}

function __sb__hasNix() {
  if [ -n "$SB_NIX_PATH" ]; then
    return 0
  else
    return 1
  fi
}

function __sb__isInsideSnowblowerShell() {
  if [ -n "$SB_IS_SHELL" ]; then
    return 0
  else
    return 1
  fi
}
