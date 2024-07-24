{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption;

  # a utility helper to standerdize integrations.
  mkIntegration = {
    name,
    package,
    settings ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} just command";
    package = mkOption {
      type = lib.types.package;
      description = "The package ${name} should use.";
      default = package;
    };
    inherit settings;
  };

  #Same as mkEnableOption but with the default set to true.
  mkEnableOption' = desc: lib.mkEnableOption "${desc}" // {default = true;};
in {
  inherit mkIntegration mkEnableOption';
}
