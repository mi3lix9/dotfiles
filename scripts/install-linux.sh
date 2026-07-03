#!/usr/bin/env bash
# install-linux.sh — apt packages for Debian/Ubuntu.
set -euo pipefail

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }

if ! command -v apt-get >/dev/null; then
  echo "This script targets Debian/Ubuntu (apt). Edit for your distro." >&2
  exit 1
fi

log "apt update"
sudo apt-get update -y

# Core CLI tools. On Debian/Ubuntu: bat->batcat, fd->fdfind.
PACKAGES=(
  zsh
  git
  curl
  wget
  fzf
  bat
  fd-find
  ripgrep
  jq
  unzip
  build-essential
  btop
)
# Note: yazi and herdr are not in apt. Install yazi via cargo/release binary
# (see https://yazi-rs.github.io/docs/installation) and herdr via its installer.

log "Installing: ${PACKAGES[*]}"
sudo apt-get install -y "${PACKAGES[@]}"

# starship prompt
if ! command -v starship >/dev/null; then
  log "Installing starship"
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
fi

# GitHub CLI (not in default apt — add the official repo)
if ! command -v gh >/dev/null; then
  log "Installing GitHub CLI"
  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y gh
fi

# gitleaks — secret scanner used by the pre-commit hook.
# In apt on Ubuntu 25.10+; fall back to the release binary on older releases.
if ! command -v gitleaks >/dev/null; then
  log "Installing gitleaks"
  if ! sudo apt-get install -y gitleaks 2>/dev/null; then
    case "$(dpkg --print-architecture)" in amd64) GA=x64 ;; arm64) GA=arm64 ;; *) GA=$(dpkg --print-architecture) ;; esac
    ver=$(curl -fsSL https://api.github.com/repos/gitleaks/gitleaks/releases/latest \
      | grep -oE '"tag_name": *"v[^"]+"' | head -1 | grep -oE '[0-9.]+')
    curl -fsSL "https://github.com/gitleaks/gitleaks/releases/download/v${ver}/gitleaks_${ver}_linux_${GA}.tar.gz" \
      | sudo tar -xz -C /usr/local/bin gitleaks
  fi
fi

# Make zsh the default shell
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  log "Setting zsh as default shell (may prompt for password)"
  chsh -s "$(command -v zsh)" || true
fi

log "install-linux.sh done"
