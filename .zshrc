HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS      # don't record duplicate consecutive commands
setopt HIST_IGNORE_SPACE     # don't record commands starting with a space
setopt SHARE_HISTORY         # share history across terminal sessions
setopt APPEND_HISTORY        # append rather than overwrite history file



export PATH="$HOME/.local/bin:$PATH"

alias ls='ls --color=auto'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

eval "$(oh-my-posh init zsh --config catppuccin_mocha)"


#if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#  eval "$(oh-my-posh init zsh --config catppuccin_mocha)"
#fi


# Enable tab completion
autoload -Uz compinit && compinit

unset rc

 alias claude='claude --allowedTools "Bash,Write,Edit,Read"'


source ~/.env
source <(fzf --zsh)

#/opt/homebrew/bin/fastfetch

mkdirc() {
    mkdir -p "$1" && cd "$1"
}
