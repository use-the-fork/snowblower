# Credits to https://github.com/nix-community/home-manager/blob/master/lib/bash/home-manager.sh
# The setup respects the `NO_COLOR` environment variable.

function doSetupColors() {
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
	if [[ ! -v NO_COLOR ]] && ([[ -t 1 ]] || [[ -n "$TERM" ]] || [[ -n "$COLORTERM" ]]); then
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
