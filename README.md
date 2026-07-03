# dotfiles

Cross-platform (macOS + Linux) dotfiles managed with
[chezmoi](https://chezmoi.io). Configs, Claude Code settings, agent skills, and
app-install scripts — one command to set up a fresh machine.

## Layout

```
.
├── install.sh              # bootstrap: install apps + apply dotfiles
├── .chezmoiroot            # tells chezmoi the source lives in home/
├── home/                   # chezmoi source (maps to $HOME)
│   ├── dot_zshrc.tmpl      # → ~/.zshrc  (templated per-OS)
│   ├── dot_config/
│   │   └── starship.toml   # → ~/.config/starship.toml
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

```sh
GH_USER=mi3lix9 \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/mi3lix9/dotfiles/main/install.sh)"
```

Or from a clone:

```sh
git clone https://github.com/mi3lix9/dotfiles.git
cd dotfiles && ./install.sh
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

A `pre-commit` hook scans staged changes for secrets before every commit. Enable
it once per clone:

```sh
git config core.hooksPath .githooks
```

Install [gitleaks](https://github.com/gitleaks/gitleaks) for full coverage
(`brew install gitleaks` / `apt install gitleaks`); without it the hook uses a
basic regex fallback.
