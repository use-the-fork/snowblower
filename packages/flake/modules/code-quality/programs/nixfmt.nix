{
  inputs,
  flake-parts-lib,
  self,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];

  flake.flakeModules.codeQuality = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      lib,
      config,
      pkgs,
      ...
    }: let
      inherit (lib) types mkOption;
      inherit (self.utils) mkCodeQualityTool mkCmdArgs;

      cfg = config.snowblower.codeQuality.programs.nixfmt;
    in {
      options.snowblower.codeQuality.programs.nixfmt = mkCodeQualityTool {
        name = "nixfmt";
        package = pkgs.nixfmt-rfc-style;
        includes = [
          "*.nix"
        ];
        extraOptions = {
          strict = mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Enable a stricter formatting mode that isn't influenced
              as much by how the input is formatted.
            '';
          };

          width = mkOption {
            type = lib.types.nullOr lib.types.int;
            default = 100;
            example = 120;
            description = ''
              Maximum width in characters [default: 100]
            '';
          };

          indent = mkOption {
            type = lib.types.nullOr lib.types.int;
            default = 2;
            example = 120;
            description = ''
              Maximum width in characters [default: 100]
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        snowblower = let
          cmdArgs = mkCmdArgs [
            [cfg.settings.strict "--strict"]
            [true "--width ${builtins.toString cfg.settings.width}"]
          ];

          finalPackage = pkgs.symlinkJoin {
            name = "nixfmt-wrapped";
            paths = [cfg.package];
            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/nixfmt --add-flags "${cmdArgs}"
            '';
          };
        in {
          packages = [
            finalPackage
          ];

          # shell = {
          #   configFiles = [{
          #       name = "nixfmt.toml";
          #       format = tomlFormat;
          #       settings = cfg.settings.configuration;
          #     }];
          # };
        };
      };
    });
  };
}
