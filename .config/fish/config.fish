set -g fish_greeting

if status is-interactive
    fish_config theme choose "Mono Smoke"
    #fish_config theme choose "Mono Lace"
end

set -gx EDITOR nvim
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
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

function ls --wraps=ls
    set -l ls_options '--group-directories-first --human-readable --classify -v'
    switch (uname)
        case Darwin
            eval gls $ls_options $argv
        case Linux
            set -l ls_cmd (type -P ls)
            eval $ls_cmd $ls_options $argv
    end
end

switch (uname)
    case Darwin
        set -gx HOMEBREW_NO_ANALYTICS 1
        set -gx HOMEBREW_NO_AUTO_UPDATE 1
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

if type -q fenv
    if test -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fenv source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >/dev/null
    end
end
