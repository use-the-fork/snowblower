{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkTool mkToolCommand;
    tomlFormat = pkgs.formats.toml {};

    cfg = config.snowblower.tool.statix;
  in {
    options.snowblower.tool.statix = mkTool {
      name = "Statix";
      package = pkgs.statix;

      lint = mkToolCommand {
        enable = true;
        exec = "statix-fix";
      };

      includes = [
        "*.nix"
      ];
    };

    config = lib.mkIf cfg.enable {
      snowblower = let
        # from https://github.com/numtide/treefmt-nix/blob/main/programs/statix.nix
        # Thanks again treefmt :)
        multipleTargetsCommand = pkgs.writeScriptBin "statix-fix" ''
          ${builtins.readFile ./../../lib-bash/utils/head.sh}

            for file in "$@"; do
              ${lib.getExe cfg.package} fix "$file"
            done
        '';
      in {
        packages.tools = [
          cfg.package
          multipleTargetsCommand
        ];

        file."statix.toml" = {
          enable = cfg.settings.config != {};
          source = tomlFormat.generate "statix.toml" cfg.settings.config;
        };
      };
    };
  });
}
