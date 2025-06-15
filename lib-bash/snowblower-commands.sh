# Commands that are specific to controling SnowBlower.
function __sb__command__switch {
     nix run .#snowblowerFiles
     return $?
}
function __sb__command__update {
     nix flake update
     return $?
}
