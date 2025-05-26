{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    any-nix-shell
    jq
    rsync
    fd
    nano
  ];
}
