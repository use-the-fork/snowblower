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
      inherit (lib) types mkOption mkIf;
      inherit (import ../utils.nix {inherit lib;}) mkEnableOption';

      cfg = config.snow-blower.integrations.treefmt;
    in {
      options.snow-blower.integrations.treefmt = {
        fileName = mkOption {
          type = types.str;
          default = "treefmt.toml";
          description = ''
            The name of the treefmt configuration file to generate.
          '';
        };

        programs = mkOption {
          type = types.attrsOf types.attrs;
          default = {};
          description = "Formatter programs to enable";
        };

        projectRoot = mkOption {
          type = types.path;
          default = self;
          defaultText = lib.literalExpression "self";
          description = ''
            Path to the root of the project on which treefmt operates
          '';
        };

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

        #automatically add treefmt-nix to pre-commit if the user enables it.
        integrations.git-hooks.hooks.treefmt.package = pkgs.treefmt;

        packages = [
          pkgs.treefmt
        ];

        shell = {
          startup = let
            # Generate the treefmt configuration file
            treefmtConfig = {
              # projectRootFile = "flake.nix";
              # projectRoot = cfg.projectRoot;
              programs = cfg.programs;
            };
            treefmtConfigFile = inputs.treefmt-nix.lib.mkConfigFile pkgs treefmtConfig;
          in [
            ''
              cp -f ${builtins.toString treefmtConfigFile} ./${cfg.fileName}
            ''
          ];
        };
      };
    });
  };
}
