{
  lib,
  pkgs,
  ...
}: let
  # a utility helper to standerdize integrations.
  mkOutOfStoreCopy = path: let
    pathStr = toString path;
    name = lib.hm.strings.storeFileName (baseNameOf pathStr);
  in
    pkgs.runCommandLocal name {} ''cp -s ${lib.escapeShellArg pathStr} $out'';
in {
  inherit mkOutOfStoreCopy;
}
