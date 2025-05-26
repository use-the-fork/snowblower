{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      name = "snow-blower-devcontainer";
      meta.description = ''
        Nix based devcontainer.
      '';

      # Set up pre-commit hooks when user enters the shell.
      shellHook = ''

      '';

      # Tell Direnv to shut up.
      DIRENV_LOG_FORMAT = "";

      # Receive packages from treefmt's configured devShell.
      inputsFrom = [
        config.treefmt.build.devShell
      ];
      packages = [
        # Packages from nixpkgs, for Nix, Flakes or local tools.
        config.treefmt.build.wrapper # Quick formatting tree-wide with `treefmt`
        pkgs.git # flakes require Git to be installed, since this repo is version controlled
        pkgs.just
        pkgs.aider-chat
      ];
    };
  };
}
