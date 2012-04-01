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
