function fish_prompt
    string join '' -- (set_color cyan) (prompt_pwd --full-length-dirs 2) (set_color normal) ' $ '
end
