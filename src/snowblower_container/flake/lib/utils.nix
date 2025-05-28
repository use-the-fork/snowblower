{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  #Same as mkEnableOption but with the default set to true.
  mkEnableOption' = desc: lib.mkEnableOption "${desc}" // {default = true;};

in {
  inherit mkEnableOption';
}
