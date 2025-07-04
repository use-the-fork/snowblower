{flake-parts-lib, ...}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.perSystem = mkPerSystemOption ({
    lib,
    config,
    pkgs,
    ...
  }: {
    config = {
      snowblower = {
        shell.zsh.initContent."starship" = ''
          if [[ $TERM != "dumb" ]]; then
            eval "$(${lib.getExe pkgs.starship} init zsh)"
          fi
        '';
      };

      packages.tools = [
        pkgs.starship
      ];
    };
  });
}
