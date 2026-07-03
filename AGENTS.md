# AGENTS.md

Guidance for AI agents (and humans) working in this dotfiles repo.

## What this repo is

Cross-platform (macOS + Linux) dotfiles managed with
[chezmoi](https://chezmoi.io). `home/` is the chezmoi **source directory** (see
`.chezmoiroot`); everything under it maps into `$HOME`.

## Conventions

- Source files use chezmoi naming: `dot_zshrc` → `~/.zshrc`,
  `dot_config/starship.toml` → `~/.config/starship.toml`.
- Files ending in `.tmpl` are Go templates — do per-OS logic with
  `{{ .chezmoi.os }}` (`"darwin"` / `"linux"`), not separate files.
- To track a **new** config, run `chezmoi add ~/.foo` — don't hand-copy files
  into `home/` (the `dot_` renaming and attributes are chezmoi's job).
- Edit tracked files with `chezmoi edit <target>` or directly under `home/`,
  then preview with `chezmoi diff` and apply with `chezmoi apply`.

## Security — this repo is PUBLIC

- **Never commit secrets**: no API keys, tokens, private keys,
  `.credentials.json`, `.claude.json`, or shell history.
- Machine-local secrets live in `~/.zshrc.local` (gitignored, auto-sourced by
  `~/.zshrc`). See `zshrc.local.example`.
- A `pre-commit` hook scans staged changes for secrets. Keep it enabled:
  `git config core.hooksPath .githooks`. Install `gitleaks` for full coverage
  (the hook falls back to a basic regex scan without it).

## App install

- `install.sh` bootstraps a machine: apps via `scripts/`, then `chezmoi apply`.
- When adding a package, update **both** `scripts/install-linux.sh` (apt) and
  `scripts/Brewfile` (macOS) so the two platforms stay in sync.
