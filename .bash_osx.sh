alias plaincopy="pbpaste -Prefer txt | pbcopy"
eval `gdircolors ~/.dir_colors`
alias ls='gls $LS_OPTIONS -hF'
export HOMEBREW_NO_ANALYTICS=1
# macOS now defaults to zsh, disable warning if you're using bash
export BASH_SILENCE_DEPRECATION_WARNING=1

# brew install bash-completion@2
if test -r "/usr/local/etc/profile.d/bash_completion.sh"; then
  source "/usr/local/etc/profile.d/bash_completion.sh"
fi
