# venv.fish -- virtualenv management with fish
# https://gist.github.com/2272033

# So the `activate.fish` script that comes in a virtualenv is unsatisfactory
# for a number of reasons: it's broken under os x and it's rigid with regards
# to prompts. virtualenvwrapper, as far as I can tell, doesn't support fish at
# all.

# this is a little nicer, i think; it saves the name of the current venv in an
# environment variable, so you can choose what you want to do with it, and it's
# fairly simple.

# it defines the following functions:
# * workon -- activates the virtualenv with the given name from $workon_home
# * deactivate -- restores the PATH to how it was before any virtualenvs were activated
# * mkvenv -- creates a virtualenv with the given name in $workon_home
# * rmvenv -- removes the virtualenv with the given name from $workon_home
# * lsvenvs -- lists the virtualenvs inside of $workon_home
# * is-venv -- check whether a virtualenv with the given name exists in $workon_home;
#   return 1 if it doesn't.
# * venv-exists -- check whether a virtualenv with the given name exists in
#   $workon_home; return 1 and print an error message if it doesn't.

set workon_home $HOME/.virtualenvs


# an environment variable to use in your prompt or whatever; you can rely on
# this to be "" when there's no active venv.
set current_venv ""


# a global where we'll store the old path before we change it.
set venv_old_path ""


function workon -d "activates the virtualenv with the given name from workon_home"
    if venv-exists $argv
        # if we're already in a venv, get out of it
        if test "$current_venv"
            deactivate
        end
        # set the $current_venv variable
        set current_venv $argv
        # remember the old PATH, so we can revert to it later
        set venv_old_path $PATH
        # add the chosen venv's /bin directory to the PATH
        set PATH $workon_home/$current_venv/bin $PATH
    end
end


function deactivate -d "restores the PATH to how it was before any virtualenvs were activated"
    # if we're already in a venv, revert to the old PATH and clear
    # $venv_old_path and $current_venv. If we're not, do nothing.
    if test "$current_venv"
        set PATH $venv_old_path
        set venv_old_path ""
        set current_venv ""
    end
end


function mkvenv -d "creates a virtualenv with the given name in workon_home"
    # if we've been given an argument: get out of the old venv (if applicable),
    # create a new venv, and workon it.
    if test "$argv"
        deactivate
        virtualenv $workon_home/$argv
        workon $argv
    end
end


function rmvenv -d "removes the virtualenv with the given name from workon_home"
    # if the virtualenv (directory) exists in $workon_home, rm -rf it.
    for v in $argv
        if venv-exists $v
            rm -rf $workon_home/$v
        end
    end
end


function lsvenvs -d "lists the virtualenvs inside of workon_home"
    # list all of the venvs (directories) in $workon_home
    for i in (ls $workon_home)
        if is-venv $i
            if test $i = $current_venv
                set_color green
                echo $i
                set_color normal
            else
                echo $i
            end
        end
    end
end


function is-venv -d "return 0 if a virtualenv with a given name exists in workon_home"
    if test -d $workon_home/$argv
        return 0
    else
        return 1
    end
end


function venv-exists -d "Print an error message if this venv doesn\'t exist in workon_home."
    if is-venv $argv
        return 0
    else
        set_color red
        echo -n "'$argv'"
        set_color normal
        echo " is not a virtualenv in $workon_home."
        return 1
    end
end


complete -c workon -x -a "(lsvenvs)"
complete -c rmvenv -x -a "(lsvenvs)"
complete -c isvenv -x -a "(lsvenvs)"
complete -c venv-exists -x -a "(lsvenvs)"
