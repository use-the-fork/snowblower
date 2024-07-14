{ pkgs, self, lib, inputs, config, ... }:
let

in {


  config = {

    enterShell =
      ''
        echo
        echo "HERE!"
        echo
      '';

  };
}
