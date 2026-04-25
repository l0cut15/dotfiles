#!/usr/bin/env bash
# bootstrap.sh — set up dotfiles on a new machine
# Usage: curl -fsSL https://raw.githubusercontent.com/l0cut15/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

DOTFILES_REPO="https://github.com/l0cut15/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

info()    { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
success() { printf '\033[1;32m[done]\033[0m  %s\n' "$*"; }
warn()    { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
die()     { printf '\033[1;31m[fail]\033[0m  %s\n' "$*" >&2; exit 1; }

OS="$(uname -s)"

# ── Step 1: Package manager baseline ─────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    info "macOS detected"

    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode Command Line Tools..."
        xcode-select --install
        info "Waiting for Xcode CLI tools to finish installing..."
        until xcode-select -p &>/dev/null; do sleep 5; done
        success "Xcode CLI tools installed"
    fi

    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if   [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]];    then eval "$(/usr/local/bin/brew shellenv)"
    fi

    if ! command -v gh &>/dev/null; then
        info "Installing gh via Homebrew..."
        brew install gh
    fi

elif [[ "$OS" == "Linux" ]]; then
    info "Linux detected"

    if command -v apt-get &>/dev/null; then
        info "Installing prerequisites via apt..."
        sudo apt-get update -qq
        sudo apt-get install -y --no-install-recommends \
            git curl gh
    else
        die "Unsupported Linux package manager. Install git and gh manually, then re-run."
    fi

else
    die "Unsupported OS: $OS"
fi

# ── Step 2: Clone dotfiles bare repo ─────────────────────────────────────────
if [[ -d "$DOTFILES_DIR" ]]; then
    warn "~/.dotfiles already exists — skipping clone"
else
    info "Cloning dotfiles bare repo..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
    success "Cloned to $DOTFILES_DIR"
fi

dotfiles() { git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"; }

# ── Step 4: Back up conflicts and check out ───────────────────────────────────
info "Checking out dotfiles..."
CONFLICTS=$(dotfiles checkout 2>&1 | grep '^\s' | grep -v '^$' | awk '{print $1}' || true)

if [[ -n "$CONFLICTS" ]]; then
    warn "Backing up conflicting files to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    while IFS= read -r file; do
        dest="$BACKUP_DIR/$(dirname "$file")"
        mkdir -p "$dest"
        mv "$HOME/$file" "$dest/"
    done <<< "$CONFLICTS"
fi

dotfiles checkout
dotfiles config status.showUntrackedFiles no
dotfiles config core.excludesfile "$HOME/.dotfiles_ignore"
success "Dotfiles checked out"

# ── Step 5: Create stub files ─────────────────────────────────────────────────
if [[ ! -f "$HOME/.env" ]]; then
    info "Creating ~/.env stub"
    cat > "$HOME/.env" << 'ENVEOF'
# Secrets — NOT tracked in git
# OPENAI_API_KEY=
# GITHUB_TOKEN=
# GITHUB_USER=
ENVEOF
fi

[[ ! -f "$HOME/.zshrc.local" ]] && touch "$HOME/.zshrc.local"

# ── Step 6: Install tools ────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    if [[ -f "$HOME/Brewfile" ]]; then
        info "Installing from Brewfile..."
        brew bundle install --file="$HOME/Brewfile" --no-lock
        success "Brewfile installed"
    fi

elif [[ "$OS" == "Linux" ]]; then
    info "Installing Linux tools via apt..."
    sudo apt-get install -y --no-install-recommends \
        zsh fzf btop htop fastfetch neovim jq bat unzip

    if ! command -v oh-my-posh &>/dev/null; then
        info "Installing oh-my-posh..."
        curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
    fi
fi

# ── Step 7: Set zsh as default shell ─────────────────────────────────────────
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    ZSH_PATH="$(command -v zsh || true)"
    if [[ -n "$ZSH_PATH" ]]; then
        info "Setting zsh as default shell..."
        grep -qF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
        sudo chsh -s "$ZSH_PATH" "$USER"
        success "Default shell set to $ZSH_PATH — re-login to apply"
    else
        warn "zsh not found — install it and run: chsh -s \$(command -v zsh)"
    fi
fi

success "Bootstrap complete. Start a new shell or run: exec zsh"
