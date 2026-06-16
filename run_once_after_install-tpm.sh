#!/bin/sh
set -eu

# Bootstrap TPM (Tmux Plugin Manager) and install declared plugins.
# ~/.config/tmux/plugins/ is excluded via .chezmoiignore, so this
# reproduces it on a fresh machine.

# Requires git + tmux. If either is missing (e.g. `brew bundle` hasn't
# run yet), skip cleanly rather than failing the whole `chezmoi apply`.
command -v git >/dev/null 2>&1 || {
  echo "tpm: git not found, skipping"
  exit 0
}
command -v tmux >/dev/null 2>&1 || {
  echo "tpm: tmux not found, skipping"
  exit 0
}

TPM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "tpm: cloning into $TPM_DIR"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "tpm: installing/updating plugins"
"$TPM_DIR/bin/install_plugins"
