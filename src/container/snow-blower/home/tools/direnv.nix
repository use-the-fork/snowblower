_: {
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  programs.direnv = {
    enable = true;
    # nix-direnv.enable = true;
    silent = true;

    # we should probably do this ourselves
    enableZshIntegration = true;
  };
}
