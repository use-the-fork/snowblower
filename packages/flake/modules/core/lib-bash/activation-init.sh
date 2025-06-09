#!/usr/bin/env bash

UNAMEOUT="$(uname -s)"

# Verify operating system is supported...
case "${UNAMEOUT}" in
    Linux*)             MACHINE=linux;;
    Darwin*)            MACHINE=mac;;
    *)                  MACHINE="UNKNOWN"
esac

if [ "$MACHINE" == "UNKNOWN" ]; then
    echo "Unsupported operating system [$(uname -s)]. SnowBlower supports macOS, Linux, and Windows (WSL2)." >&2
    exit 1
fi

# Determine if stdout is a terminal...
if test -t 1; then
    # Determine if colors are supported...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test "$ncolors" -ge 8; then
        # Text attributes
        BOLD="$(tput bold)"
        # UNDERLINE="$(tput smul)"
        # BLINK="$(tput blink)"
        # REVERSE="$(tput rev)"
        NC="$(tput sgr0)"  # No Color

        # Regular colors
        # BLACK="$(tput setaf 0)"
        # RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
        YELLOW="$(tput setaf 3)"
        # BLUE="$(tput setaf 4)"
        # MAGENTA="$(tput setaf 5)"
        # CYAN="$(tput setaf 6)"
        # WHITE="$(tput setaf 7)"
    fi
fi