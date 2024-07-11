#!/usr/bin/env nix-build
# Used to test the shell
{ system ? builtins.currentSystem }:
let
  snow-blower = import ./. { inherit system; };
in
snow-blower.mkShell {

}
