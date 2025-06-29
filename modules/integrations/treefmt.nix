{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkIntegration;

    tomlFormat = pkgs.formats.toml {};
    cfg = config.snowblower.integration.treefmt;
  in {
    options.snowblower.integration.treefmt = mkIntegration {
      name = "Treefmt";
      package = pkgs.treefmt;
      config = {
        "tree-root" = "snow";
        excludes = [
          ".snowblower"
        ];
      };
    };

    config.snowblower = lib.mkIf cfg.enable {
      command."treefmt" = {
        displayName = "Treefmt";
        description = "formatter multiplexer";
        command = "treefmt";
        env = "tools";
      };

      packages.tools = [
        cfg.package
      ];

      file."treefmt.toml" = let
        formatters =
          lib.mapAttrs
          (
            name: tool:
              lib.optionalAttrs (tool.enable && (tool.settings.format.enable or false)) {
                "formatter.${lib.toLower name}-format" =
                  lib.filterAttrs (
                    _n: v:
                      v
                      != null
                      && (
                        if builtins.isList v
                        then v != []
                        else true
                      )
                  ) {
                    command = tool.settings.format.exec;
                    options = tool.settings.format.args or [];
                    inherit (tool.settings) includes;
                    inherit (tool.settings) excludes;
                    inherit (tool.settings.format) priority;
                  };
              }
          )
          config.snowblower.tool;

        linters =
          lib.mapAttrs
          (
            name: tool:
              lib.optionalAttrs (tool.enable && (tool.settings.lint.enable or false)) {
                "formatter.${lib.toLower name}-lint" =
                  lib.filterAttrs (
                    _n: v:
                      v
                      != null
                      && (
                        if builtins.isList v
                        then v != []
                        else true
                      )
                  ) {
                    command = tool.settings.lint.exec;
                    options = tool.settings.lint.args or [];
                    inherit (tool.settings) includes;
                    inherit (tool.settings) excludes;
                    inherit (tool.settings.lint) priority;
                  };
              }
          )
          config.snowblower.tool;

        finalConfiguration =
          lib.foldl' lib.recursiveUpdate {}
          (lib.attrValues formatters ++ lib.attrValues linters);
      in {
        enable = true;
        source = tomlFormat.generate "treefmt.toml" finalConfiguration;
      };
    };
  });
}
