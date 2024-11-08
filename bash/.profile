# Read: What startup files are read by the shell? (shell configuration)
# http://hayne.net/MacDev/Notes/unixFAQ.html#shellStartup
# https://apple.stackexchange.com/questions/12993/why-doesnt-bashrc-run-automatically/13014#13014

# APPS ########################################################################
# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# direnv
#eval "$(direnv hook bash)"
eval "$(direnv hook $(echo $0))"

# MacDown
# macdown() {
#   "$(mdfind kMDItemCFBundleIdentifier=com.uranusjr.macdown | head -n1)/Contents/SharedSupport/bin/macdown" $@
# }

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pipenv
export PATH=$PATH:~/Library/Python/3.9/bin


# PATH ########################################################################
# Located at: /etc/path
# Sublime
export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"  # subl


# CONSTANTS ###################################################################

# Colors:
# * Wikipedia: https://en.wikipedia.org/wiki/ANSI_escape_code
# * Stackoverflow: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[1;93m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_WHITE="\[\033[0;97m\]"
ORANGE="\[\033[38;5;214m\]"

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# BITCOIN #####################################################################
# Function to fetch Bitcoin price from CoinGecko and store it in an environment variable
function refresh_btc_json_cache() {
    # Path to the cache file (we're using environment variables here)
    local cache_var_name="BTC_JSON_CACHE"

    # Get the current timestamp (in seconds)
    local current_time=$(date +%s)

    # Check if the cache is empty or needs to be refreshed
    if [[ -z "${!cache_var_name}" ]]; then
        # Cache is empty, make an API request
        fetch_btc_data
    else
        # Parse the last updated timestamp from the cached JSON
        local last_updated_at=$(echo "${!cache_var_name}" | jq -r '.bitcoin.last_updated_at')

        # Calculate the time difference in seconds
        local time_diff=$((current_time - last_updated_at))

        # If the cached data is older than 30 minutes (1800 seconds), refresh it
        # API rate is "~30 calls per minutes" -> ~1 call / 2 secs
        # https://docs.coingecko.com/reference/common-errors-rate-limit#rate-limit
        #
        if [[ $time_diff -gt 2 ]]; then
            fetch_btc_data
        fi
    fi
}

# Function to fetch the data from the CoinGecko API and store it in an environment variable
function fetch_btc_data() {
    # Fetch the full JSON response
    local btc_json=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true")

    # Store the full JSON in an environment variable
    export BTC_JSON_CACHE="$btc_json"

    # Optionally, you can also print the data or the price:
    #local price=$(echo "$btc_json" | jq -r '.bitcoin.usd')
    #echo "Updated BTC Price: $price"
}

# Function to extract and format the BTC price, 24h change, and 24h percentage change for the prompt
function print_btc_info() {
    # Refresh BTC data
    refresh_btc_json_cache

    local price=$(echo "$BTC_JSON_CACHE" | jq -r '.bitcoin.usd')
    local change_percentage=$(echo "$BTC_JSON_CACHE" | jq -r '.bitcoin.usd_24h_change')

    # Determine if the change is positive or negative
    if [[ "$change_percentage" > 0 ]]; then
        change_symbol="+"
    else
        change_symbol="-"
    fi

    # Format price with 2 decimal places and add the dollar sign
    local price_formatted=$(printf "$%'0.2f" "$price")

    # Format the percentage change with 2 decimals
    local change_percentage_formatted=$(printf "%.2f%%" "$change_percentage")

    # Apply orange color
    # echo -e "\033[38;5;214m$price_formatted\033[0m$ change_symbol\033[38;5;214m$change_percentage_formatted\033[0m$ (\033[38;5;214m$change_symbol$change_percentage_formatted%\033[0m)"
    echo -e "\033[38;5;214m$price_formatted $change_symbol$change_percentage_formatted\033[0m"
}


# PROMPT ######################################################################

# Parse git branch
parse_git_branch() {
  git branch 2> /dev/null | grep '*' | awk '{ print $2" " }'
}

export PS1="\$(print_btc_info) $(date +%H:%M) $GREEN\w $YELLOW\$(parse_git_branch)$LIGHT_GRAY"


# ALIAS #######################################################################

alias c='clear'
alias py=python
alias py3=python3
alias pip="python3 -m pip"

# ls commands
alias l=ls
alias l1='ls -G1'
alias ls='ls -G'
alias ll='ls -Glh'
alias lll=la
alias la='ls -Glah'

# cd commands
alias ..='cd ..'
alias ~='cd ~'
alias home='cd ~'

#27 Resume wget by default
alias wget='wget -c'

# Set some other defaults 
alias df='df -H'
alias du='du -cH'

# New set of commands
alias t='tree'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%Y-%m-%d"'

# History
alias hs='history | grep'
alias svi='sudo vi'
# Unixtime
#alias ts="python3 ~/canva/data-analytics-tools/misc/utcts.py"

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
alias gu='git checkout master && git pull' # update master
# Git banch, checkout, and set upstream
git_branch_new() {
  # Start from an updated master
  # git checkout master && git pull
  # Create branch, checkout into it, and set upstream
  git branch "$1" && git checkout "$1" && git push --set-upstream origin "$1"
}
alias gbn='git_branch_new' # create new branch, check it out, and set upstream

#25: Get system memory, cpu usage, and gpu memory info quickly
## Pass options to free
#alias meminfo='free -m -l -t'
## Get top process eating memory
#alias psmem='ps auxf | sort -nr -k 4'
#alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## Get top process eating cpu ##
#alias pscpu='ps auxf | sort -nr -k 3'
#alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
## Get server cpu info
#alias cpuinfo='lscpu'
## Older system use /proc/cpuinfo
##alias cpuinfo='less /proc/cpuinfo'
## Get GPU ram on desktop / laptop
#alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
