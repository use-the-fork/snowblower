{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkIntegration mkOption types;

    tomlFormat = pkgs.formats.toml {};
    cfg = config.snowblower.integration.oxker;
    inherit (config.snowblower.command."oxker") exec;
  in {
    options.snowblower.integration.oxker = mkIntegration {
      name = "Oxker";
      package = pkgs.oxker;
      config = {};
    };

    config.snowblower = lib.mkIf cfg.enable {
      command."oxker" = {
        displayName = "Oxker";
        description = "Docker tui";
        command = "oxker";
        # subcommand = {
        #   "gen" = {
        #     description = "Generate a changelog";
        #     command = exec;
        #     args = [
        #       "-o"
        #       cfg.settings.fileName
        #     ];
        #   };
        # };
      };

      packages = [
        cfg.package
      ];

      # file."cliff.toml" = {
      #   enable = true;
      #   source = tomlFormat.generate "cliff.toml" cfg.settings.config;
      # };
    };
  });
}
