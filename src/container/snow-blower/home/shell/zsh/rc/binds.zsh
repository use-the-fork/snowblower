# C-right / C-left for word skips
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# C-Backspace / C-Delete for word deletions
bindkey "^[[3;5~" forward-kill-word
bindkey "^H" backward-kill-word

# Home/End
bindkey "^[[OH" beginning-of-line
bindkey "^[[OF" end-of-line

# open commands in $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^V" edit-command-line
