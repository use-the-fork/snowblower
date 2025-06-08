# ARGS=()
if [ "$1" == "switch" ]; then
    nix run .#snowblower-files
fi