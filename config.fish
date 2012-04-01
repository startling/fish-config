set PATH /usr/local/share/python ~/code/bin /usr/local/bin $PATH

# source all of the files in the function directory
for f in (find ~/.config/fish/functions -type f)
    . $f
end
