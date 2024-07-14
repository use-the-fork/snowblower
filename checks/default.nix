{ pkgs, inputs, snow-blower, ... }:
let
  inherit (pkgs) lib;

  join = lib.concatStringsSep;

  toConfig = name:
    snow-blower.mkConfigFile pkgs {
      programs.${name}.enable = true;
    };

  sbEval = snow-blower.evalModule pkgs inputs ../snowblower.nix;

  sbDocEval = snow-blower.evalModule stubPkgs ../snowblower.nix;

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

    # Expose the current devshell
    self-shell = sbEval.config.build.devShell;

    # Check that the docs render properly
    module-docs = (pkgs.nixosOptionsDoc { options = sbEval.options; }).optionsCommonMark;
  };
in
self
