function doHelp {
  echo "❄️ 💨 SnowBlower: All flake no fluff."
  echo
  echo "${YELLOW}Usage:${NC}" >&2
  echo "  snow COMMAND [options] [arguments]"
  echo
  echo "${YELLOW}SnowBlower Commands:${NC}"
  echo "  ${GREEN}snow switch${NC}          Regenerate all config files"
  echo "  ${GREEN}snow update${NC}          Update all dependencies by updating the Flake (Nix flake update)"
  echo "  ${GREEN}snow reboot${NC}          Erase current session and reset vars"
  echo
  echo "${YELLOW}docker-compose Commands:${NC}"
  echo "  ${GREEN}snow docker up${NC}        Start the application"
  echo "  ${GREEN}snow docker up -d${NC}     Start the application in the background"
  echo "  ${GREEN}snow docker down${NC}      Stop the application"
  echo "  ${GREEN}snow docker restart${NC}   Restart the application"
  echo "  ${GREEN}snow docker build${NC}     Builds all containers in compose file"
  echo "  ${GREEN}snow docker ps${NC}        Display the status of all containers"
  echo
  displayResolvedCommands
  echo
  exit 1
}
