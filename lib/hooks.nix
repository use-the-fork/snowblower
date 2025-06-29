{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit
    (lib.types)
    oneOf
    listOf
    attrsOf
    str
    bool
    int
    float
    path
    either
    lines
    ;

  valueType = oneOf [
    bool
    int
    float
    str
    path
    (attrsOf valueType)
    (listOf valueType)
  ];

  mkHook = {name}: {
    pre = mkOption {
      type = lib.sbl.types.dagOf lines;
      default = {};
      description = ''
        Scripts to run before ${name}.
      '';
    };

    post = mkOption {
      type = lib.sbl.types.dagOf lines;
      default = {};
      description = ''
        Scripts to run after ${name}.
      '';
    };
  };
in {
  inherit mkHook;
}
