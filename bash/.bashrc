# Colors
# Sources:
# * Wikipedia: https://en.wikipedia.org/wiki/ANSI_escape_code
# * Stackoverflow: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[1;93m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_WHITE="\[\033[0;97m\]"

# Direnv
#eval "$(direnv hook bash)"
eval "$(direnv hook $(echo $0))"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# PATH
export PATH="$HOME/.embulk/bin:$PATH"
export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"

# Git branch
parse_git_branch() { 
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/ '
}

# Prompt
# "username@hostname:/path/to/current/directory (git_branch) $ "
#export PS1="\u@\h:$GREEN\w$YELLOW\$(parse_git_branch)$LIGHT_GRAY $ "
# Alias - https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
# "hh:mm /path/to/current/directory (git-branch) $ "
#export PS1="\$(date +%H:%M) $GREEN\w$YELLOW\$(parse_git_branch) $LIGHT_GRAY$ "
#
# "hh:mm /path/to/current/directory (git-branch) $ "
#export PS1="\$(date +%H:%M) $GREEN\w$YELLOW\$(parse_git_branch) $LIGHT_GRAY"
#
# "hh:mm /path/to/current/directory (git-branch) "
#export PS1="\$(date +%H:%M) $GREEN\w$YELLOW\$(parse_git_branch) $LIGHT_GRAY"
#
# "hh:mm /path/to/current/directory git-branch "
# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/ '
export PS1="\$(date +%H:%M) $GREEN\w$YELLOW\$(parse_git_branch) $LIGHT_GRAY"

alias c='clear'
alias py=python
alias py3=python3
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
# New set of commands
alias t='tree'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%Y-%m-%d"'

#25: Get system memory, cpu usage, and gpu memory info quickly
## pass options to free ##
#alias meminfo='free -m -l -t'
## get top process eating memory
#alias psmem='ps auxf | sort -nr -k 4'
#alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## get top process eating cpu ##
#alias pscpu='ps auxf | sort -nr -k 3'
#alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
## Get server cpu info ##
#alias cpuinfo='lscpu'
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
## get GPU ram on desktop / laptop##
#alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

#27 Resume wget by default
alias wget='wget -c'

## Set some other defaults ##
alias df='df -H'
alias du='du -cH'

# Pretty print JSON - use: echo '{"foo": "bar"}' | prettyjson
alias prettyjson='python -m json.tool'
# Pretty JSON from string
prettyjson_s() {
    echo "$1" | python -m json.tool
}
# Pretty JSON from file
prettyjson_f() {
    python -m json.tool "$1"
}
# Pretty JSON from web API
prettyjson_w() {
    curl "$1" | python -m json.tool
}

# Git alias
# alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gl="git log --format='%Cred%h%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset%C(yellow)%d%Creset' --no-merges"
alias gs='git branch -vv && git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m '
alias gp='git push'
alias gco='git checkout'
alias gcom='git checkout master'
alias gb='git branch -vv'
# gb(){
#   git branch $1 && git checkout $1
# }

# History
alias hs='history | grep'
alias svi='sudo vi'

# MacDown
macdown() {
    "$(mdfind kMDItemCFBundleIdentifier=com.uranusjr.macdown | head -n1)/Contents/SharedSupport/bin/macdown" $@
}
