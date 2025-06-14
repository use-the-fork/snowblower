{lib}: let
  typesDag = import ./dag.nix {inherit lib;};
in {
  inherit (typesDag) dagOf;
}
