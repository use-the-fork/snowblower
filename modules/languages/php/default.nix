{flake-parts-lib, ...}: {
  imports = [
    ./composer.nix
  ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkLanguage types mkOption;
    inherit (types) nullOr lines listOf str;

    cfg = config.snowblower.language.php;
  in {
    options.snowblower.language.php = mkLanguage {
      name = "PHP";
      package = pkgs.php83;
      settings = {
        ini = mkOption {
          type = nullOr lines;
          default = "";
          description = ''
            PHP.ini directives. Refer to the "List of php.ini directives" of PHP's
          '';
        };

        extensions = mkOption {
          type = listOf str;
          default = [];
          description = ''
            PHP extensions to enable.
          '';
        };

        disableExtensions = mkOption {
          type = listOf str;
          default = [];
          description = ''
            PHP extensions to disable.
          '';
        };
      };
    };

    config.snowblower = lib.mkIf cfg.enable {
      packages.runtime = [
        cfg.package
      ];
    };
  });
}
