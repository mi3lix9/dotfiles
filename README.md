# dotfiles

Cross-platform (macOS + Linux) dotfiles managed with
[chezmoi](https://chezmoi.io). Configs, Claude Code and Pi settings, agent skills, and
app-install scripts — one command to set up a fresh machine.

## Layout

```
.
├── install.sh              # bootstrap: install apps + apply dotfiles
├── .chezmoiroot            # tells chezmoi the source lives in home/
├── home/                   # chezmoi source (maps to $HOME)
│   ├── dot_zshrc.tmpl      # → ~/.zshrc  (templated per-OS)
│   ├── dot_aerospace.toml  # → ~/.aerospace.toml  (macOS tiling WM)
│   ├── dot_config/
│   │   ├── starship.toml   # → ~/.config/starship.toml
│   │   ├── ghostty/config  # terminal emulator
│   │   ├── yazi/           # file manager (keymap + plugin manifest)
│   │   ├── btop/           # system monitor
│   │   └── herdr/config.toml   # terminal multiplexer (replaces tmux)
│   ├── dot_pi/agent/          # → ~/.pi/agent/  (Pi coding agent)
│   │   ├── settings.json      # packages + theme (auth.json is NOT tracked)
│   │   ├── caveman.json       # terse-mode defaults
│   │   ├── zentui.json        # TUI layout
│   │   └── extensions/        # local Pi extensions (e.g. herdr)
│   └── dot_claude/
│       ├── settings.json   # → ~/.claude/settings.json
│       └── skills/         # → ~/.claude/skills/  (agent skills)
├── scripts/
│   ├── common.sh           # cross-platform (omz, plugins, nvm)
│   ├── install-linux.sh    # apt packages
│   ├── install-macos.sh    # Homebrew + Brewfile
│   └── Brewfile
├── .githooks/pre-commit    # gitleaks secret scan
└── zshrc.local.example     # template for machine-local secrets
```

## Install on a new machine

Clone and run the bootstrap:

```sh
git clone https://github.com/mi3lix9/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Or one-liner (no clone):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mi3lix9/dotfiles/main/install.sh)"
```

### Using this as your own dotfiles

Fork the repo, then either edit the `mi3lix9` default in `install.sh`, or point
the bootstrap at your fork without editing anything:

```sh
DOTFILES_REPO=https://github.com/<you>/dotfiles.git \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/<you>/dotfiles/main/install.sh)"
```

## Daily use

```sh
chezmoi edit ~/.zshrc     # edit a tracked file (opens the source)
chezmoi add ~/.config/foo # start tracking a new file
chezmoi diff              # preview pending changes
chezmoi apply             # apply source → $HOME
chezmoi update            # git pull + apply (sync another machine)
```

## Secrets

Nothing secret lives in this repo. Machine-local values (API keys, tokens) go in
`~/.zshrc.local`, which is gitignored and sourced automatically by `~/.zshrc`.
Copy `zshrc.local.example` to `~/.zshrc.local` to start.
Pi credentials live in `~/.pi/agent/auth.json` (gitignored). Do not add that file.

A `pre-commit` hook scans staged changes for secrets before every commit. Enable
it once per clone:

```sh
git config core.hooksPath .githooks
```

Install [gitleaks](https://github.com/gitleaks/gitleaks) for full coverage
(`brew install gitleaks` / `apt install gitleaks`); without it the hook uses a
basic regex fallback.
