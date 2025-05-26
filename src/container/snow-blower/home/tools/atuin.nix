_: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # https://docs.atuin.sh/configuration/config/
      search_mode = "fuzzy";
      filter_mode = "global";

      history_filter = [
        "^ls"
      ];
    };
  };
}
