{
  inputs,
  flake-parts-lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.git-hooks.flakeModule
  ];
  flake.flakeModules.integrations = {
    options.perSystem = flake-parts-lib.mkPerSystemOption ({
      self',
      lib,
      pkgs,
      config,
      ...
    }: let
      inherit (lib) types mkDefault;
      inherit (import ../utils.nix {inherit pkgs lib;}) mkHook;

      commitlint-config = pkgs.writeTextFile {
        name = ".commitlintrc.yml";
        text = ''
          rules:
            description-empty: # Description must not be empty
              level: error
            subject-empty: # Subject line must not be empty
              level: error
            type:
              level: error
              options:
                - build
                - chore
                - ci
                - docs
                - feat
                - fix
                - perf
                - refactor
                - revert
                - style
                - test
            type-empty: # Type must not be empty
              level: error
        '';
      };

      commitlint-entry = pkgs.writeShellScriptBin "commitlint-entry" ''
        # The first argument is the file where the commit message is stored
        commit_msg=$(cat $1)
        if [[ $commit_msg != "Merge"* ]]; then
          echo $commit_msg | ${pkgs.commitlint-rs}/bin/commitlint \
          --config ${commitlint-config.outPath}
        fi
      '';

    in {

      config.snow-blower.integrations.git-hooks = {
        hooks.commitlint = mkHook "commitlint" {
          enable = mkDefault false;
          entry = "${commitlint-entry}/bin/commitlint-entry";
          stages = ["prepare-commit-msg"];
        };
      };
    });
  };
}
