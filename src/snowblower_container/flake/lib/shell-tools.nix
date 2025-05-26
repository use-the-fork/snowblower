{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  # a utility helper to standerdize tools.
  mkShellTool = {
    name,
    package,
    settings ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} CLI Utility";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    inherit settings;
  };

in {
   inherit mkShellTool;
}
