{lib, ...}: let
  #Same as mkEnableOption but with the default set to true.
  mkEnableOption' = desc: lib.mkEnableOption "${desc}" // {default = true;};
in mkEnableOption'


