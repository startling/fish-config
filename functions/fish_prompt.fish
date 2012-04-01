function with_color
    # set the color to the first argument
    set_color $argv[1]
    # delete that argument
    set -e argv[1]
    # and then pass the rest to echo, so we can do things like
    # `with_color cyan -n hi`.
    echo $argv
    # and then go back to normal
    set_color normal
end

function fish_prompt
    if test $current_venv
        with_color cyan -n "[$current_venv] "
    end

    with_color $fish_color_cwd -n (prompt_pwd)

    echo " » "
end
