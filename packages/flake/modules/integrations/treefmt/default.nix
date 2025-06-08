{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) mkIf;
      inherit (self.utils) mkConfigFile mkEnableOption';

      tomlFormat = pkgs.formats.toml {};

      cfg = config.snow-blower.integrations.treefmt;
    in {
      options.snow-blower.integrations.treefmt = {
        just.enable = mkEnableOption' "enable just command";
      };

      config.snow-blower = {
        #automatically add treefmt-nix to just.
        just.recipes.treefmt = mkIf cfg.just.enable {
          enable = lib.mkDefault true;
          justfile = lib.mkDefault ''
            # Auto-format the source tree using treefmt
            fmt:
              treefmt
          '';
        };

        packages = [
          pkgs.treefmt
        ];

        wrapper = let
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
                      inherit (tool.settings.format) command;
                      options = tool.settings.format.args or [];
                      inherit (tool.settings) includes;
                      inherit (tool.settings) excludes;
                      inherit (tool.settings.format) priority;
                    };
                }
            )
            config.snow-blower.codeQuality;

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
                      inherit (tool.settings.lint) command;
                      options = tool.settings.lint.args or [];
                      inherit (tool.settings) includes;
                      inherit (tool.settings) excludes;
                      inherit (tool.settings.lint) priority;
                    };
                }
            )
            config.snow-blower.codeQuality;

          finalConfiguration =
            lib.foldl' lib.recursiveUpdate {}
            (lib.attrValues formatters ++ lib.attrValues linters);
        in
          mkConfigFile {
            name = "treefmt.toml";
            format = tomlFormat;
            settings = finalConfiguration;
          };
      };
    });
  };
}
