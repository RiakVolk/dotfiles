#
# ~/.bashrc
#

# ──────────────────────────────────────────────
# Exit if not interactive
# ──────────────────────────────────────────────
[[ $- != *i* ]] && return

# ──────────────────────────────────────────────
# PATH (early, once)
# ──────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ──────────────────────────────────────────────
# History — fish-like behavior
# ──────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:cd -:pwd:exit:clear"

# Append, don't overwrite
shopt -s histappend

# Save after every command
PROMPT_COMMAND="history -a; history -n"

# Search history by typing (like fish)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ──────────────────────────────────────────────
# Colors (safe)
# ──────────────────────────────────────────────
RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'

RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
WHITE='\[\e[37m\]'

# ──────────────────────────────────────────────
# Colored prompt
# ──────────────────────────────────────────────

# Starship prompt (Omarchy style)
PS1="${BOLD}${BLUE}[\u@${GREEN}\h ${CYAN}\W${BLUE}]${RESET}\$ "
eval "$(starship init bash)"

# ──────────────────────────────────────────────
# Aliases
# ──────────────────────────────────────────────
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias rr='ranger'
alias cl='clear'
alias minecraft='~/GOG\ Games/Minecraft/Minecraft/Minecraft\ 1.21.8/start'
# ──────────────────────────────────────────────
# Bash completion (system)
# ──────────────────────────────────────────────
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi

#added for navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# ──────────────────────────────────────────────
# NVM (safe load)
# ──────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ──────────────────────────────────────────────
# Zoxide (smart cd replacement)
# ──────────────────────────────────────────────
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

# ──────────────────────────────────────────────
# fzf — fish-style fuzzy history + path completion
# ──────────────────────────────────────────────
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
  export FZF_CTRL_R_OPTS="--preview 'echo {}'"
  export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git 2>/dev/null || find ."
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d"

  # Keybindings:
  # CTRL+R → fuzzy history (fish-like)
  # CTRL+T → fuzzy file insert
  # ALT+C  → fuzzy cd
  [ -f /usr/share/fzf/key-bindings.bash ] && . /usr/share/fzf/key-bindings.bash
fi

# Load Angular CLI autocompletion.
source <(ng completion script)
export PATH="$HOME/.cargo/bin:$PATH"

# pnpm
export PNPM_HOME="/home/volk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
