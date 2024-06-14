set -g fish_greeting

if status is-interactive
  fish_config theme choose "tokyonight-day"
end

set -gx LS_OPTIONS '--color=auto'
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
set -gx HISTCONTROL ignoreboth
set -gx PATH $HOME/bin $PATH
set -gx PIP_REQUIRE_VIRTUALENV true

switch (uname)
  case Darwin
    alias ls 'gls $LS_OPTIONS -hF'
    set -gx HOMEBREW_NO_ANALYTICS 1
  case Linux
    alias ls 'ls $LS_OPTIONS -hF'
end

if type -q fzf
  fzf --fish | source
end

if test -r ~/.asdf/asdf.fish
  source ~/.asdf/asdf.fish
  mkdir -p ~/.config/fish/completions
  if not test -f ~/.config/fish/completions/asdf.fish
    ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
  end
end

alias vi nvim
alias vim nvim
alias cwdiff 'wdiff -n -w \'\033[30;41m\' -x \'\033[0m\' -y \'\033[30;42m\' -z \'\033[0m\''
