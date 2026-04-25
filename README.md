# dotfiles

Personal configuration files managed with a bare git repo.

---

## Quick start

```zsh
curl -fsSL https://raw.githubusercontent.com/l0cut15/dotfiles/main/bootstrap.sh | bash
```

That one command handles everything on macOS and Ubuntu/Debian Linux.

---

## What bootstrap.sh does

1. Installs Xcode Command Line Tools (macOS) or updates apt (Linux)
2. Installs Homebrew (macOS only)
3. Installs `gh`
4. Clones this repo as a bare git repo to `~/.dotfiles/`
5. Backs up any conflicting existing files to `~/.dotfiles-backup/`
6. Checks out all tracked dotfiles into `$HOME`
7. Creates stub `~/.env` and `~/.zshrc.local` files
8. Installs all tools (via Brewfile on macOS, apt + oh-my-posh script on Linux)
9. Sets zsh as your default shell if not already

Each step is idempotent — safe to re-run after a partial failure.

---

## Before you run bootstrap

Requires internet access only. The repo is public so no authentication is needed.

macOS: an installer dialog opens for Xcode Command Line Tools.

---

## Pushing dotfiles from a new machine

Bootstrap sets up `gh` but does not authenticate it — the repo is public so read access needs no credentials. If you want to push dotfiles changes from this machine, authenticate after bootstrap:

```zsh
gh auth login
```

On headless machines, use a token:

```zsh
gh auth login --with-token < my-token.txt
```

---

## After bootstrap: machine-specific config

Two files are created but not tracked in git:

**`~/.env`** — secrets and API keys:
```
OPENAI_API_KEY=
GITHUB_TOKEN=
GITHUB_USER=
```

**`~/.zshrc.local`** — machine-specific shell config:
```zsh
# Example: project-specific tool version managers
# eval "$(pyenv init - zsh)"

# Example: sourcing a custom tool's completions
# [[ -f ~/.mycli/completions/mycli.zsh ]] && source ~/.mycli/completions/mycli.zsh
```

---

## Daily usage

The `dotfiles` alias wraps git for the bare repo:

```zsh
dotfiles status                   # see what has changed
dotfiles add ~/.zshrc             # stage a file
dotfiles commit -m "update zshrc"
dotfiles push                     # push to GitHub
dotfiles pull                     # pull updates on another machine
```

### Adding a new config file

```zsh
dotfiles add ~/.config/someapp/config
dotfiles commit -m "add someapp config"
dotfiles push
```

### Pulling updates on an existing machine

```zsh
dotfiles pull
source ~/.zshrc
```

---

## What is and isn't tracked

| Tracked | Not tracked |
|---------|-------------|
| `~/.zshrc` | `~/.zshrc.local` (machine-specific) |
| `~/.gitconfig` | `~/.env` (secrets) |
| `~/.mytheme.omp.json` | `~/.ssh/` |
| `~/.config/btop/btop.conf` | `~/.claude/` |
| `~/.config/htop/htoprc` | `~/.config/rclone/` |
| `~/.config/zellij/config.kdl` | |
| `~/Brewfile` | |
| `~/bootstrap.sh` | |
