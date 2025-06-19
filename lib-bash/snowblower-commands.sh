# Commands that are specific to controling SnowBlower.
function doSwitch {
  (cd "$SB_SRC_ROOT" && nix run .#snowblowerFiles) 
  return 0
}
function doUpdate {
  executeWithSpinner "Updating Flake" "nix flake update"
  doSwitch
  doReboot
  return 0
}

function doReboot() {
  rm -f "$SB_SESS_FILE"
  doBoot
  return 0
}
