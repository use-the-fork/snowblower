# Function to ask user for confirmation before proceeding
function confirmAction {
	local message="$1"
	local response

	echo -n "${message} (y/N): "
	read -r response

	case "$response" in
	[yY] | [yY][eE][sS])
		return 0
		;;
	*)
		echo "Operation cancelled."
		exit 0
		;;
	esac
}

expand_vars() {
	local arg="$1"
	# Use eval to expand variables, but escape special characters first
	eval "echo \"$arg\""
}
