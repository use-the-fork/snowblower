{ pkgs, inputs, snow-blower, ... }:
let
  inherit (pkgs) lib;

  join = lib.concatStringsSep;

  toConfig = name:
    snow-blower.mkConfigFile pkgs {
      programs.${name}.enable = true;
    };

  treefmtEval = snow-blower.evalModule pkgs inputs ../snowblower.nix;

  treefmtDocEval = snow-blower.evalModule stubPkgs ../snowblower.nix;

  stubPkgs =
    lib.mapAttrs
      (k: _: throw "The module documentation must not depend on pkgs attributes such as ${lib.strings.escapeNixIdentifier k}")
      pkgs
    // {
      _type = "pkgs";
      inherit lib;
      # Formats is ok and supported upstream too
      inherit (pkgs) formats;
    };

  self = {

    # Check if the examples folder needs to be updated
    #    examples = pkgs.runCommand
    #      "test-examples"
    #      {
    #        passthru.examples = examples;
    #      }
    #      ''
    #        if ! diff -r ${../examples} ${examples}; then
    #          echo "The generated ./examples folder is out of sync"
    #          echo "Run ./examples.sh to fix the issue"
    #          exit 1
    #        fi
    #        touch $out
    #      '';

    # Check that the repo is formatted
    #    self-formatting = treefmtEval.config.build.check ../.;

    # Expose the current wrapper
    self-wrapper = treefmtEval.config.build.devShell;

    # Check that the docs render properly
    module-docs = (pkgs.nixosOptionsDoc { options = treefmtEval.options; }).optionsCommonMark;
  };
in
self
