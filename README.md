# dotfiles

Personal configuration files managed with a bare git repo.

---

## Bootstrap a new machine

### 1. Install prerequisites

Ensure `git` and `gh` are installed, then authenticate:

```zsh
gh auth login
gh auth setup-git
```

### 2. Clone the bare repo

```zsh
git clone --bare https://github.com/l0cut15/dotfiles.git ~/.dotfiles
```

### 3. Check out the files

If existing files conflict, back them up first:

```zsh
mkdir -p ~/.dotfiles-backup
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 \
  | grep "already exists" \
  | awk '{print $1}' \
  | xargs -I{} mv ~/{} ~/.dotfiles-backup/{}
```

Then check out:

```zsh
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
```

### 4. Create local secrets and machine-specific config

```zsh
touch ~/.env         # add your API keys and tokens
touch ~/.zshrc.local # add machine-specific shell config (not tracked)
```

`.env` variables needed:

```
OPENAI_API_KEY=
GITHUB_TOKEN=
GITHUB_USER=
```

`~/.zshrc.local` examples (machine-specific):

```zsh
# macOS — nothing required by default
# Linux (rpi5)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
[[ -f ~/.openclaw/completions/openclaw.zsh ]] && source ~/.openclaw/completions/openclaw.zsh
```

### 5. Reload your shell

```zsh
source ~/.zshrc
```

---

## Daily usage

The `dotfiles` alias wraps git for the bare repo:

```zsh
dotfiles status                  # see what has changed
dotfiles add ~/.zshrc            # stage a file
dotfiles commit -m "update zshrc"
dotfiles push                    # push to GitHub
dotfiles pull                    # pull updates on another machine
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
