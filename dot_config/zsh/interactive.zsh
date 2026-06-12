# ~/.config/zsh/interactive.zsh

# PATH for non-login interactive shells.
[[ -f "$XDG_CONFIG_HOME/zsh/path.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/path.zsh"

# History (default location: ~/.zsh_history)
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_dups hist_reduce_blanks

# Completion (keep the dump in XDG cache, not $HOME)
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Prompt: starship
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# fzf interactive integration.
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# Aliases.
[[ -f "$XDG_CONFIG_HOME/zsh/aliases.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
