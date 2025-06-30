{
  flake-parts-lib,
  self,
  ...
}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) types mkOption literalExpression optional mkDefault mkEnableOption mkLanguage;

    cfg = config.snowblower.languages.java;
  in {
    options.snowblower.languages.java = mkLanguage {
      name = "Java";
      package = pkgs.jdk;
      settings = {
        maven = {
          enable = mkEnableOption "maven";
          package = mkOption {
            type = types.package;
            defaultText = "pkgs.maven.override { jdk = cfg.package; }";
            description = ''
              The Maven package to use.
              The Maven package by default inherits the JDK from `languages.java.package`.
            '';
          };
        };
        gradle = {
          enable = mkEnableOption "gradle";
          package = mkOption {
            type = types.package;
            defaultText = literalExpression "pkgs.gradle.override { java = cfg.package; }";
            description = ''
              The Gradle package to use.
              The Gradle package by default inherits the JDK from `languages.java.package`.
            '';
          };
        };
      };
    };

    config.snowblower = lib.mkIf cfg.enable {
      # env = {
      #   M2_HOME = config.snowblower.env.PROJECT_STATE + "/m2";
      #   GRADLE_USER_HOME = config.snowblower.env.PROJECT_STATE + "/gradle";
      #   JAVA_HOME = config.snowblower.languages.java.package;
      # };

      # languages.java = {
      #   settings.maven.package = mkDefault (pkgs.maven.override {jdk_headless = cfg.package;});
      #   settings.gradle.package = mkDefault (pkgs.gradle.override {java = cfg.package;});
      # };

      # packages.runtime =
      #   (optional cfg.enable cfg.package)
      #   ++ (optional cfg.settings.maven.enable cfg.settings.maven.package)
      #   ++ (optional cfg.settings.gradle.enable cfg.settings.gradle.package);
    };
  });
}
