{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.languages = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkOption literalExpression attrValues getAttrs optional mkDefault mkEnableOption;
      inherit (import ../utils.nix {inherit lib;}) mkLanguage;

      filterDefaultExtensions = ext: builtins.length (builtins.filter (inner: inner == ext.extensionName) cfg.disableExtensions) == 0;

      configurePackage = package:
        package.buildEnv {
          extensions = {
            all,
            enabled,
          }:
            with all; (builtins.filter filterDefaultExtensions (enabled ++ attrValues (getAttrs cfg.extensions package.extensions)));
          extraConfig = cfg.ini;
        };

      cfg = config.snow-blower.languages.java;
      srv = config.snow-blower.services;
    in {
      options.snow-blower.languages.java = mkLanguage {
        name = "Java";
        package = pkgs.jdk;
        settings = {
          maven = {
            enable = mkEnableOption "maven";
            package = mkOption {
              type = types.package;
              defaultText = "pkgs.maven.override { jdk = cfg.jdk.package; }";
              description = ''
                The Maven package to use.
                The Maven package by default inherits the JDK from `languages.java.jdk.package`.
              '';
            };
          };
          gradle = {
            enable = mkEnableOption "gradle";
            package = mkOption {
              type = types.package;
              defaultText = literalExpression "pkgs.gradle.override { java = cfg.jdk.package; }";
              description = ''
                The Gradle package to use.
                The Gradle package by default inherits the JDK from `languages.java.jdk.package`.
              '';
            };
          };
        };
      };

      config.snow-blower = lib.mkIf cfg.enable {
        languages.java = {
          settings.maven.package = mkDefault (pkgs.maven.override { jdk = cfg.package; });
          settings.gradle.package = mkDefault (pkgs.gradle.override { java = cfg.package; });
        };

        packages = (optional cfg.enable cfg.package)
          ++ (optional cfg.settings.maven.enable cfg.settings.maven.package)
          ++ (optional cfg.settings.gradle.enable cfg.settings.gradle.package);

      };
    });
  };
}
