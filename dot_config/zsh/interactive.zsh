# ~/.config/zsh/interactive.zsh

# PATH for non-login interactive shells.
[[ -f "$XDG_CONFIG_HOME/zsh/path.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/path.zsh"

# History (default location: ~/.zsh_history)
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_dups hist_reduce_blanks

# Completion
# (zsh-completiongs must be on fpath BEFORE compinit)
# (keep the dump in XDG cache, not $HOME)
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit && compinit -i -d "$ZSH_COMPDUMP"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Prompt: starship
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# zoxide (smart cd)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# mise (runtime/version manager)
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

# bat: theme + man pages
export BAT_THEME="TwoDark"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# fzf (fd-backed + bat preview)
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
fi

# gcloud / gsutil / bq completion (after compinit)
[[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ]] \
  && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc

# sesh: Alt-s opens a session picker from the shell
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# With tmux extended-keys=always, zsh sees CSI-u Shift+Enter directly.
if [[ -n "$TMUX" ]]; then
  bindkey -M emacs $'\e[13;2u' accept-line
  bindkey -M viins $'\e[13;2u' accept-line
  bindkey -M vicmd $'\e[13;2u' accept-line
  bindkey -M emacs $'\e[27;2;13~' accept-line
  bindkey -M viins $'\e[27;2;13~' accept-line
  bindkey -M vicmd $'\e[27;2;13~' accept-line
fi

# zsh-autosuggestions
[[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Aliases.
[[ -f "$XDG_CONFIG_HOME/zsh/aliases.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/aliases.zsh"

# Work Aliases.
[[ -f "$XDG_CONFIG_HOME/zsh/aliases.work.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/aliases.work.zsh"

# zsh-syntax-highlighting — MUST be sourced LAST
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
