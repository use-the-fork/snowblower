{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
  in {
    options.snowblower = {
      shell = {
        zsh = {
          initContent = mkOption {
            type = lib.sbl.types.dagOf types.lines;
            default = {};
            description = ''
              Content to be added to the zsh configuration file.

              This option allows you to add custom zsh initialization code
              that will be included in the generated zshrc file. The content
              is organized using a DAG (Directed Acyclic Graph) to ensure
              proper ordering of initialization steps.
            '';
          };

          zshrcFile = mkOption {
            internal = true;
            type = types.package;
          };
        };
      };
    };

    config = {
      snowblower = {
        shell.zsh.zshrcFile = let
          zshInitContent = lib.sbl.dag.resolveDag {
            name = "snowblower runtime post hooks";
            dag = config.snowblower.shell.zsh.initContent;
            mapResult = result:
              lib.concatLines (map (entry: entry.data) result);
          };
        in
          pkgs.writeText "zshrc" ''
            # Snowblower zsh configuration
            ${zshInitContent}
          '';

        packages.tools = [
          pkgs.zsh
        ];
      };
    };
  });
}
