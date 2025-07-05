{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkShellIntegration;

    tomlFormat = pkgs.formats.toml {};
    cfg = config.snowblower.shell.atuin;
  in {
    options.snowblower.shell.atuin = mkShellIntegration {
      name = "Atuin";
      package = pkgs.atuin;
      extraOptions = {
      };
    };

    config.snowblower = lib.mkIf cfg.enable {
      shell.zsh.initContent."atuin" = ''
        if [[ $TERM != "dumb" ]]; then
          eval "$(${lib.getExe cfg.package} init zsh)"
        fi
      '';

      environmentVariables.ATUIN_CONFIG_DIR = "\${SB_PROJECT_STATE}/atuin";

      directories = [
        "\${SB_PROJECT_STATE}/atuin"
      ];

      file."/snowblower/state/atuin/config.toml" = {
        enable = true;
        source = tomlFormat.generate "atuin-config.toml" {
          db_path = "/snowblower/state/atuin/.history.db";
          key_path = "/snowblower/state/atuin/.atuin-key";
          auto_sync = false;
          update_check = false;
          store_failed = false;
        };
      };

      packages.tools = [
        cfg.package
      ];
    };
  });
}
