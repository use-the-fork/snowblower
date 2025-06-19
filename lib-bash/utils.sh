# Credits: https://github.com/srid/flake-root/blob/master/flake-module.nix
# This function is used to find the flake root and set it as a env varible.
findUp() {
  ancestors=()
  while true; do
  if [[ -f $1 ]]; then
      echo "$PWD"
      exit 0
  fi
  ancestors+=("$PWD")
  if [[ $PWD == / ]] || [[ $PWD == // ]]; then
      echo "Unable to locate ${1}"
      exit 1
  fi
  cd ..
  done
}

function createTouchFile() {
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

function createDirectory() {
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
