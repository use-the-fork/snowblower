{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.strings) fileContents;
in {
  programs.zsh = {
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # avoid duplicated entries in PATH
        typeset -U PATH

        # try to correct the spelling of commands
        setopt correct
        # disable C-S/C-Q
        setopt noflowcontrol
        # disable "no matches found" check
        unsetopt nomatch

        # autosuggests otherwise breaks these widgets.
        # <https://github.com/zsh-users/zsh-autosuggestions/issues/619>
        ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-beginning-search-backward-end history-beginning-search-forward-end)

        # Do this early so fast-syntax-highlighting can wrap and override this
        if autoload history-search-end; then
          zle -N history-beginning-search-backward-end history-search-end
          zle -N history-beginning-search-forward-end  history-search-end
        fi

        source ${config.programs.git.package}/share/git/contrib/completion/git-prompt.sh
      '')

      (lib.mkOrder 550 ''
        bindkey "\e[3~" delete-char

        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE='48'
        ZSH_AUTOSUGGEST_USE_ASYNC='true'
        ZSH_AUTOSUGGEST_MANUAL_REBIND='true'
      '')

      (lib.mkAfter ''
        # my helper functions for setting zsh options that I normally use on my shell
        # a description of each option can be found in the Zsh manual
        # <https://zsh.sourceforge.io/Doc/Release/Options.html>
        # NOTE: this slows down shell startup time considerably
        ${fileContents ./rc/unset.zsh}
        ${fileContents ./rc/set.zsh}

        # binds, zsh modules and everything else
        ${fileContents ./rc/binds.zsh}
        ${fileContents ./rc/misc.zsh}

        # Set LS_COLORS by parsing dircolors output
        LS_COLORS="$(${pkgs.coreutils}/bin/dircolors --sh)"
        LS_COLORS="''${''${LS_COLORS#*\'}%\'*}"
        export LS_COLORS
      '')
    ];
  };
}
