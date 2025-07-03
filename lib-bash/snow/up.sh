function doSnowUpLogic() {
	# Execute pre-up hooks
	doHook__up__pre

	# Check if SnowBlower docker container is already running
	if isSnowBlowerDockerContainerUp; then
		_iError "SnowBlower container is already running. Use 'snow down' to stop it first."
		return 1
	fi

	# Start docker-compose detached
	runDockerCompose --profile auto-start up --detach --remove-orphans "$@"
	doRoutedCommandExecute "tools" "snowblower-hooks" "tools_pre"

	return 0
}

function doSnowUp {
	doSnowUpWithMenu "$@"
}

function doSnowUpWithMenu() {
	doSnowUpLogic "$@"
	if [ $? -eq 1 ]; then
		exit 1
	fi

	# Clear screen and show persistent menu with logs
	while true; do
		clear
		echo "${YELLOW}SnowBlower Menu:${NC}"
		echo "  ${GREEN}q${NC} - Quit and stop containers"
		echo
		echo "${YELLOW}Logs (last 20 lines):${NC}"
		echo "────────────────────────────────────────"

		# Show last 20 lines of logs
		runDockerCompose logs --tail=20 2>/dev/null || echo "No logs available yet..."

		echo "────────────────────────────────────────"
		echo -n "Press 'q' to quit or any other key to refresh: "

		# Read single character without timeout
		read -n 1 choice
		case "$choice" in
		q | Q)
			echo
			echo "Shutting down..."
			doRoutedCommandExecute "tools" "snowblower-hooks" "tools_post"
			doSnowDownLogic
			exit 0
			;;
		*)
			# Any other key refreshes the display
			continue
			;;
		esac
	done
}
