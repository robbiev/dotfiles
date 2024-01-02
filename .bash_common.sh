alias vi=vim
alias cwdiff="wdiff -n -w $'\033[30;41m' -x $'\033[0m' -y $'\033[30;42m' -z $'\033[0m'"
PS1='\[\e[0;32m\][\[\e[m\]\u\[\e[1;31m\] \w\[\e[m\]\[\e[0;32m\]]\[\e[m\]
\[\e[1;37m\]\$\[\e[m\] '
export LS_OPTIONS='--color=auto'
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export HISTCONTROL=ignoreboth
export PATH="~/bin:$PATH"
#export SSH_AUTH_SOCK="/usr/local/var/run/yubikey-agent.sock"
export PIP_REQUIRE_VIRTUALENV=true

function 1p {
  if [[ ! -z "${OP_SESSION_my}" ]]; then
    echo "already signed in"
    return
  fi
  eval $(op signin my)
}
