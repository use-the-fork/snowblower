{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs) eza bat ripgrep dust procs;
in {
  programs.zsh.shellAliases = {
    # make sudo use aliases
    sudo = "sudo ";

    # quality of life aliases
    cat = "${getExe bat} --style=plain";
    grep = "${getExe ripgrep}";
    du = "${getExe dust}";
    ps = "${getExe procs}";
    mp = "mkdir -p";
    fcd = "cd $(find -type d | fzf)";
    ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension -l --group";
    l = "ls -lF --time-style=long-iso --icons";

    # system aliases
    la = "${getExe eza} -lah --tree";
    tree = "${getExe eza} --tree --icons=always";

    # faster navigation
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };
}
