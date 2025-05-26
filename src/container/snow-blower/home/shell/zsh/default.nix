{
  config,
  lib,
  ...
}: {
  imports = [
    ./aliases.nix
    ./init.nix
    ./plugins.nix
  ];

  config = {
    programs.zsh = {
      enable = true;

      autosuggestion = {
        enable = true;
        highlight = "fg=8";
        strategy = lib.mkForce ["completion"];
      };

      dotDir = ".config/zsh";

      enableCompletion = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {LC_ALL = "en_US.UTF-8";};
    };
  };
}
