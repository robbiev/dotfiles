set -g fish_greeting

if status is-interactive
    fish_config theme choose "Solarized Dark"
end

set -gx LS_OPTIONS '--color=auto'
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=dark
"

# $HOME/.local/bin for tools installed with "uv"
set -gx PATH $HOME/.local/bin $HOME/bin $HOME/go/bin $PATH
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

if type -q mise
    mise activate fish | source
end

if type -q keychain
    keychain --quiet
    if test -f ~/.keychain/(hostname)-fish
        source ~/.keychain/(hostname)-fish
    end
end

if type -q fenv
    if test -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fenv source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >/dev/null
    end
end
