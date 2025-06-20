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