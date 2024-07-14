# List all the files in this folder.
let
  # All the directory entries, except default.nix. We assume they are all
in
{
  # The module filenames
  modules = [
    ./integrations/git-hooks
    ./integrations/just
    ./integrations/treefmt
  ];
}
