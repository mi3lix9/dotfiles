#!/usr/bin/env bash
#
# install.sh — one-shot bootstrap. Installs apps, then applies dotfiles.
#
# From a local clone (recommended):
#   ./install.sh
#
# Fresh machine, no clone:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/mi3lix9/dotfiles/main/install.sh)"
#
# Using a fork without editing this file:
#   DOTFILES_REPO=https://github.com/<you>/dotfiles.git sh -c "$(curl -fsSL .../install.sh)"
#
set -euo pipefail

log()  { printf '\033[1;36m::\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

GH_USER="${GH_USER:-mi3lix9}"
REPO_URL="${DOTFILES_REPO:-https://github.com/$GH_USER/dotfiles.git}"

# ── 1. Detect OS ───────────────────────────────────────────────────────────
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *)      die "Unsupported OS: $(uname -s)" ;;
esac
log "Detected OS: $OS"

# ── 2. Locate the repo (local clone vs remote bootstrap) ───────────────────
SELF="${BASH_SOURCE:-$0}"
if [ -f "$SELF" ] && [ -d "$(dirname "$SELF")/scripts" ]; then
  HERE="$(cd "$(dirname "$SELF")" && pwd)"
  log "Using local repo at $HERE"
else
  # Bootstrapped via curl — chezmoi will clone the repo itself in step 4.
  HERE=""
  command -v git >/dev/null || die "git is required to bootstrap"
fi

# ── 3. Install apps ────────────────────────────────────────────────────────
if [ -n "$HERE" ]; then
  log "Running package scripts"
  bash "$HERE/scripts/common.sh"
  bash "$HERE/scripts/install-$OS.sh"
fi

# ── 4. Install chezmoi ─────────────────────────────────────────────────────
if ! command -v chezmoi >/dev/null; then
  log "Installing chezmoi"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# ── 5. Apply dotfiles ──────────────────────────────────────────────────────
if [ -n "$HERE" ]; then
  log "Applying dotfiles from local source"
  chezmoi init --apply --source "$HERE"
else
  log "Cloning + applying dotfiles from $REPO_URL"
  chezmoi init --apply "$REPO_URL"
  # Package scripts live in the cloned source dir; run them now.
  SRC="$(chezmoi source-path 2>/dev/null)/.."
  bash "$SRC/scripts/common.sh"
  bash "$SRC/scripts/install-$OS.sh"
fi

log "Done. Restart your shell:  exec zsh"
