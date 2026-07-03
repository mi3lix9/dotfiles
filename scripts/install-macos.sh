#!/usr/bin/env bash
# install-macos.sh — Homebrew + Brewfile.
set -euo pipefail

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Homebrew ──────────────────────────────────────────────────────────────
if ! command -v brew >/dev/null; then
  log "Installing Homebrew"
  /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

log "brew bundle"
brew bundle --file="$HERE/Brewfile"

# Make zsh the default shell (macOS ships zsh already)
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  log "Setting zsh as default shell"
  chsh -s "$(command -v zsh)" || true
fi

log "install-macos.sh done"
