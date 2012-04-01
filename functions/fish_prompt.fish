function fish_prompt
    if test $current_venv
        with_color cyan -n "[$current_venv] "
    end

    with_color $fish_color_cwd -n (prompt_pwd)

    echo " » "
end
