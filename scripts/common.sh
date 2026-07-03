#!/usr/bin/env bash
# common.sh — cross-platform setup shared by macOS and Linux.
# Idempotent: safe to run repeatedly.
set -euo pipefail

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# ── Oh My Zsh ─────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local repo="$1" dest="$ZSH_CUSTOM/plugins/$2"
  [ -d "$dest" ] || { log "Plugin: $2"; git clone --depth=1 "$repo" "$dest"; }
}

clone_plugin https://github.com/zsh-users/zsh-autosuggestions       zsh-autosuggestions
clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting   zsh-syntax-highlighting
clone_plugin https://github.com/zsh-users/zsh-completions           zsh-completions
clone_plugin https://github.com/Aloxaf/fzf-tab                      fzf-tab

# ── nvm (node version manager) ────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm"
  PROFILE=/dev/null bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
fi

log "common.sh done"
