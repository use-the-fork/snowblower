{
  pkgs,
  inputs,
  snowblower,
  ...
}: let
  sbEval = snowblower.evalModule pkgs inputs ../snowblower.nix;

  self = {
    # Expose the current devshell
    self-shell = sbEval.config.build.devShell;

    # Check that the docs render properly
    module-docs = (pkgs.nixosOptionsDoc {inherit (sbEval) options;}).optionsCommonMark;
  };
in
  self
