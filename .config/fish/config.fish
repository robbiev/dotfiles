set -g fish_greeting

if status is-interactive
  fish_config theme choose "tokyonight-day"
end

set -gx LS_OPTIONS '--color=auto'
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_day.sh
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#b6bfe2 \
  --color=bg:#e9e9ec \
  --color=border:#2496ac \
  --color=fg:#3760bf \
  --color=gutter:#e9e9ec \
  --color=header:#b15c00 \
  --color=hl+:#188092 \
  --color=hl:#188092 \
  --color=info:#8990b3 \
  --color=marker:#d20065 \
  --color=pointer:#d20065 \
  --color=prompt:#188092 \
  --color=query:#3760bf:regular \
  --color=scrollbar:#2496ac \
  --color=separator:#b15c00 \
  --color=spinner:#d20065 \
"
set -gx PATH $HOME/bin $HOME/go/bin $PATH
set -gx PIP_REQUIRE_VIRTUALENV true

switch (uname)
  case Darwin
    alias ls 'gls $LS_OPTIONS -hF'
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
  case Linux
    alias ls 'ls $LS_OPTIONS -hF'
end

alias vi nvim
alias vim nvim
alias cwdiff 'wdiff -n -w \'\033[30;41m\' -x \'\033[0m\' -y \'\033[30;42m\' -z \'\033[0m\''

if test -r $HOME/.machineconfig/fish/config.fish
  source $HOME/.machineconfig/fish/config.fish
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

if type -q mise
  mise activate fish | source
end
