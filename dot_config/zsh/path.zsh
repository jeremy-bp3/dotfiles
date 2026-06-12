# ~/.config/zsh/path.zsh

# Deduplicate PATH entries while preserving first occurrence.
typeset -U path PATH

# Homebrew initialization.
#
# On Apple Silicon Macs, Homebrew normally lives here:
#   /opt/homebrew
#
# The /usr/local fallback is useful if this config is ever reused on
# an Intel Mac or in an unusual environment.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User-local paths.
#
# Keep these small and explicit. Language/version-manager paths can be
# added later when you configure those tools.
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

export PATH
