{flake-parts-lib, ...}: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkIntegration;

    yamlFormat = pkgs.formats.yaml {};
    cfg = config.snowblower.integration.git;
  in {
    options.snowblower.integration.git = mkIntegration {
      name = "Git";
      package = pkgs.git;
      config = {
      };
    };

    config = lib.mkIf cfg.enable {
      snowblower = {
        packages.tools = [
          cfg.package
        ];

        hook.up.pre."git" = ''
          # Set local git config from global if global exists and local doesn't
          if git config --global user.name >/dev/null 2>&1 && ! git config user.name >/dev/null 2>&1; then
            git config user.name "$(git config --global user.name)"
            _iNote "Set local git user.name to: $(git config user.name)"
          fi
          if git config --global user.email >/dev/null 2>&1 && ! git config user.email >/dev/null 2>&1; then
            git config user.email "$(git config --global user.email)"
            _iNote "Set local git user.email to: $(git config user.email)"
          fi
        '';
      };
    };
  });
}
