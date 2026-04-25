# ─── History ─────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ─── PATH ─────────────────────────────────────────────────────────────────────
typeset -U path PATH

[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/bin"        ]] && path=("$HOME/bin"         $path)

# Homebrew — detect whichever prefix exists (macOS ARM, macOS Intel, Linux)
if   [[ -x /opt/homebrew/bin/brew ]];              then eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]];                 then eval "$(/usr/local/bin/brew shellenv zsh)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# nvm (only if installed)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Cargo / Rust (only if installed)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

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
command -v oh-my-posh &>/dev/null && eval "$(oh-my-posh init zsh --config catppuccin_mocha)"

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
command -v fzf &>/dev/null && source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ─── Fastfetch ────────────────────────────────────────────────────────────────
command -v fastfetch &>/dev/null && fastfetch

# ─── Environment & secrets ────────────────────────────────────────────────────
[[ -f ~/.env ]] && source ~/.env

# ─── Machine-specific overrides ───────────────────────────────────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
