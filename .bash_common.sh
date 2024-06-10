PS1='\[\e[0;32m\][\[\e[m\]\u\[\e[1;31m\] \w\[\e[m\]\[\e[0;32m\]]\[\e[m\]
\[\e[1;37m\]\$\[\e[m\] '

export LS_OPTIONS='--color=auto'
export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export HISTCONTROL=ignoreboth
export PATH="$HOME/bin:$PATH"
export PIP_REQUIRE_VIRTUALENV=true

if command -v fzf > /dev/null; then
  eval "$(fzf --bash)"
fi

if test -r  "$HOME/.asdf/asdf.sh"; then
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"
fi

alias vi=nvim
alias vim=nvim
alias cwdiff="wdiff -n -w $'\033[30;41m' -x $'\033[0m' -y $'\033[30;42m' -z $'\033[0m'"
