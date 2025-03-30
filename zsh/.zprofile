# .zshprofile

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pipenv
export PATH=$PATH:~/Library/Python/3.9/bin

# MacDown (commented out in original)
# macdown() {
#   "$(mdfind kMDItemCFBundleIdentifier=com.uranusjr.macdown | head -n1)/Contents/SharedSupport/bin/macdown" $@
# }

# Sublime Text (adjust for Zsh)
export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"  # subl

# Ensure PATH and other environment variables are exported
export HISTSIZE=1000
export HISTFILESIZE=2000
