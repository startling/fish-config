set PATH /usr/local/share/python ~/code/bin /usr/local/bin ~/.cabal/bin $PATH

# vim and some other things rely on SHELL being a posixy sh this may cause
# problems in the future, in which case I'll define a little function to wrap
# vim and give it a fake environment variable.
set SHELL (which sh)

# no motd
set fish_greeting ""

# source all of the files in the function directory
for f in (find ~/.config/fish/functions -type f)
    . $f
end
