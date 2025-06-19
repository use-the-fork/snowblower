# Commands that are specific to controling SnowBlower.
function __sb__command__switch {
  cd $SB_SRC_ROOT
  nix run .#snowblowerFiles
  return 0
}
function __sb__command__update {
  cd $SB_SRC_ROOT
  executeWithSpinner "Updating Flake" "nix flake update"
  __sb__command__switch
  __sb__command__reboot
  return 0
}

function __sb__command__reboot() {
  cd $SB_SRC_ROOT
  rm -f "$SB_SESS_FILE"
  __sb__bootSnowBlowerEnvironment
  return 0
}
