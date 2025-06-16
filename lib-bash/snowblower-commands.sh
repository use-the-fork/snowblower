# Commands that are specific to controling SnowBlower.
function __sb__command__switch {
     nix run .#snowblowerFiles
     return $?
}
function __sb__command__update {
     nix flake update
     __sb__command__switch
     __sb__command__reboot
     return $?
}

function __sb__command__reboot() {
    rm -f "$SB_SESS_FILE"
    __sb__bootSnowBlowerEnvironment
    return 0
}