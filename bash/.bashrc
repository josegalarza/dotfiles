# Colors
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"

eval "$(direnv hook bash)"

# PATH
export PATH="$HOME/.embulk/bin:$PATH"

# Git branch
parse_git_branch() { 
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Prompt
# "username@hostname:/path/to/current/directory (git_branch) $ "
#export PS1="\u@\h:$GREEN\w$YELLOW\$(parse_git_branch)$LIGHT_GRAY $ "
# "hh:mm /path/to/current/directory (git-branch) $ "
export PS1="\$(date +%H:%M) $GREEN\w$YELLOW\$(parse_git_branch)$LIGHT_GRAY $ "                                                                                       

# Alias - https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
# ls commands
alias l=ls
alias l1='ls -G1'
alias ls='ls -G'
alias ll='ls -Glh'
alias la='ls -Glah'
# cd commands
alias ..='cd ..'
alias ~='cd ~'
alias home='cd ~'
# New set of commands
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
