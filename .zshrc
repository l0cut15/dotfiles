# ─── History ─────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ─── PATH ─────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH"
else
    export PATH="$HOME/.local/bin:$PATH"
fi

# ─── Aliases ──────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias claude='claude --allowedTools "Bash,Write,Edit,Read"'

# ─── Functions ────────────────────────────────────────────────────────────────
mkdirc() {
    mkdir -p "$1" && cd "$1"
}

# ─── Prompt ───────────────────────────────────────────────────────────────────
eval "$(oh-my-posh init zsh --config catppuccin_mocha)"

# ─── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [[ "$OSTYPE" != "darwin"* ]]; then
    eval "$(dircolors -b)"
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# ─── fzf ──────────────────────────────────────────────────────────────────────
source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ─── Fastfetch ────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    /opt/homebrew/bin/fastfetch
else
    /usr/bin/fastfetch
fi

# ─── Environment & secrets ────────────────────────────────────────────────────
source ~/.env

# ─── Machine-specific overrides ───────────────────────────────────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
