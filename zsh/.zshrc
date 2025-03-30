# .zshrc

# Colors for prompt (Zsh uses $PROMPT and $RPROMPT)
# zsh
# autoload -U colors && colors
RED="%F{red}"
YELLOW="%F{yellow}"
LIGHT_YELLOW="%F{yellow}%b"
GREEN="%F{green}"
LIGHT_GREEN="%F{lightgreen}"
LIGHT_GRAY="%F{gray}"
LIGHT_WHITE="%F{white}"
ORANGE="%F{orange}"
# # bash
# RED="\[\033[0;31m\]"
# YELLOW="\[\033[0;33m\]"
# LIGHT_YELLOW="\[\033[1;93m\]"
# GREEN="\[\033[0;32m\]"
# LIGHT_GREEN="\[\033[1;32m\]"
# LIGHT_GRAY="\[\033[0;37m\]"
# LIGHT_WHITE="\[\033[0;97m\]"

# Define functions for Bitcoin Price display
function refresh_btc_json_cache() {
    local cache_var_name="BTC_JSON_CACHE"
    local current_time=$(date +%s)

    if [[ -z "${!cache_var_name}" ]]; then
        fetch_btc_data
    else
        local last_updated_at=$(echo "${!cache_var_name}" | jq -r '.bitcoin.last_updated_at')
        local time_diff=$((current_time - last_updated_at))
        if [[ $time_diff -gt 2 ]]; then
            fetch_btc_data
        fi
    fi
}

function fetch_btc_data() {
    local btc_json=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true")
    export BTC_JSON_CACHE="$btc_json"
}

function print_btc_info() {
    refresh_btc_json_cache

    local price=$(echo "$BTC_JSON_CACHE" | jq -r '.bitcoin.usd')
    local change_percentage=$(echo "$BTC_JSON_CACHE" | jq -r '.bitcoin.usd_24h_change')

    if [[ "$change_percentage" > 0 ]]; then
        change_symbol="+"
    else
        change_symbol="-"
    fi

    local price_formatted=$(printf "$%'0.2f" "$price")
    local change_percentage_formatted=$(printf "%.2f%%" "$change_percentage")

    echo -e "${ORANGE}$price_formatted $change_symbol$change_percentage_formatted${RESET}"
}

# Git branch parsing function
function parse_git_branch() {
  branch=$(git branch 2>/dev/null | grep '*' | awk '{print $2}')
  if [[ -n "$branch" ]]; then
    echo "$branch "
  fi
}

# # Ensure parse_git_branch is autoloaded
# autoload -Uz parse_git_branch

# # Use precmd to ensure the function is evaluated dynamically:
# precmd() {
#   parse_git_branch
# }

# Enable prompt substitution to allow functions like parse_git_branch
setopt PROMPT_SUBST

# Setting up prompt (PS1) with Bitcoin info and git branch
export PS1='%T %F{green}%~ %F{yellow}$(parse_git_branch)%f'

# Aliases for convenience
alias c='clear'
alias py=python
alias py3=python3
alias pip="python3 -m pip"

# ls commands
alias l='ls'
alias l1='ls -G1'
alias ls='ls -G'
alias ll='ls -Glh'
alias lll=la
alias la='ls -Glah'

# cd commands
alias ..='cd ..'
alias ~='cd ~'
alias home='cd ~'

# Resume wget by default
alias wget='wget -c'

# System info
alias df='df -H'
alias du='du -cH'

# Git commands
alias gl="git log --format='%Cred%h%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset%C(yellow)%d%Creset' --no-merges"
alias gs='git branch -vv && git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m '
alias gp='git push'
alias gco='git checkout'
alias gcom='git checkout master'
alias gb='git branch -vv'
alias gu='git checkout master && git pull'

# New Git branch creation
git_branch_new() {
  git branch "$1" && git checkout "$1" && git push --set-upstream origin "$1"
}
alias gbn='git_branch_new'
