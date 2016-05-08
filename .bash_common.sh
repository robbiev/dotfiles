alias vim=nvim
alias vi=nvim
alias plaincopy="pbpaste -Prefer txt | pbcopy"
alias cwdiff="wdiff -n -w $'\033[30;41m' -x $'\033[0m' -y $'\033[30;42m' -z $'\033[0m'"
PS1='\[\e[0;32m\][\[\e[m\]\u\[\e[1;31m\] \w\[\e[m\]\[\e[1;32m\]]
\[\e[m\]\[\e[1;37m\]\$\[\e[m\] '
export LS_OPTIONS='--color=auto'
eval `gdircolors ~/.dir_colors`
alias ls='gls $LS_OPTIONS -hF'
export EDITOR=vim
