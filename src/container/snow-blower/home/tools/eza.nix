{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    enableZshIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
