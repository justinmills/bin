#! /bin/bash

if [ $TERM != dumb ] ; then
    echo "setting up..."
fi

IS_WINDOWS=false
if [[ "$(uname)" = CYGWIN* ]] ; then
    IS_WINDOWS=true
fi

# ------------------------------------------------------------------------------
# Helpful functions

function firefox {
    open /Applications/Firefox.app $@
}

function chrome {
    open /Applications/Google\ Chrome.app --args $@
}

function incognito {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --incognito $@
}

function pass {
  security find-generic-password -l "$1" -g 2>&1 | grep "^password:" | sed 's/password: "//g' | sed 's/"//g'
}

function explorer {
    app=~/"Applications (Parallels)/{fb9f7cda-07b6-4948-b17d-66e23c3661ae} Applications.localized/File Explorer.app"
    if [ "$@" = . ] ; then
        open "${app}" --args $PWD
    else
        open "${app}" --args $@
    fi
}

# ------------------------------------------------------------------------------
# Aliases

# alias foo="git status"

# Relies on saml2aws setup
alias aws-prod="saml2aws console -a prod && saml2aws login -a prod"
alias aws-feature="saml2aws console -a feature && saml2aws login -a feature"

# ------------------------------------------------------------------------------
# JAVA...

export JAVA_HOME="$(/usr/libexec/java_home)"

# ------------------------------------------------------------------------------
# Postgres (need this to be able to use psql to connect to a docker running pg instance)

# export PGHOST=127.0.0.1
# export PGUSER=diesel

# Building the python psycopg library doesn't work with brew ssl for some reason out of the box.
# Need to specify some additional args
export LDFLAGS="${LDFLAGS} -I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"

# ------------------------------------------------------------------------------
# Editor

# This is a script I keep in bin. Basically a wrapper around emacsclient
export EDITOR=emacsclient

# ------------------------------------------------------------------------------
# Path setup

sep=:
if  $IS_WINDOWS ; then
    sep=;
fi
function add-to-path {
  export PATH="${1}${sep}${PATH}"
}

if $IS_WINDOWS ; then
    # TODO: set a default path?
    true
else
    export PATH_BREW=/usr/local/bin:/usr/local/sbin
    export PATH_OS=/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
    export PATH=${PATH_BREW}:${PATH_OS}
fi
add-to-path ~/bin-private
add-to-path ~/bin
add-to-path /Applications/Emacs.app/Contents/MaxOS/bin
add-to-path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# Elastic Beanstalk CLI
# (https://github.com/aws/aws-elastic-beanstalk-cli-setup)
add-to-path ~/.ebcli-virtual-env/executables

if [ -e ~/code/ellevation/main/tools/bin ] ; then
    add-to-path ~/code/ellevation/main/tools/bin
fi

# This is where pipx puts things
add-to-path ~/.local/bin

# ------------------------------------------------------------------------------
# Completions

# Bash completions. I use homebrew for this now, so much of this is legacy or for macports.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
# Completions for screen wrapper
complete -F _known_hosts scr

# ------------------------------------------------------------------------------
# PS1 prompt

# Setup prompt
if [ $TERM != dumb ] ; then
    #PS1='\h:\W$(__git_ps1 "(%s)") \u\$ '

    # Tried this, but it seemed to break
    #PS1='[\e[1;33m\w\e[m\e[3;32m$(__git_ps1 "(git-%s)")\e[m]$ '

    # This is sam's; he's had luck with it.
    # Green user@host, Blue directory $ (optional git branch info)
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(__git_ps1 "\[\033[01;33m\](%s)")\[\033[00m\]$ '
else
    PS1='[\w$(__git_ps1 "(git-%s)")]$ '
    #PS1='\s-\v\$ '

    # Also for git on dumb terms, less is not a good thing...use cat instead
    export PAGER=cat
fi

# ------------------------------------------------------------------------------
# Misc settings

# Tell Homebrew not to auto-update anytime you run a brew install command
export HOMEBREW_NO_AUTO_UPDATE=1

# Tell mac tar to not put the garbage in tarballs that messes with real unix systems.
# http://www.unwin.org/solr_error_in_opening_zip_file.html
export COPYFILE_DISABLE=true

# Save unified history
# http://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals
export PROMPT_COMMAND_HISTORY='history -a'

# Before we get too far, let's set PROMPT_COMMAND as others set it below
export PROMPT_COMMAND="${PROMPT_COMMAND_HISTORY}"

# If there is a file with myget creds, let's source it. Kinda evil to have these floating around,
# but better than littering each repo with a .env file with the creds in them, IMO.
#
# Temporarily set -a so they're auto-exported too.
if [ -f ~/.myget-credentials ] ; then
    set -a
    source ~/.myget-credentials
    set +a
fi

# ------------------------------------------------------------------------------
# Done..with everything that isn't wired in via third party...
if [ $TERM != dumb ] ; then
    echo Done with .bashrc
fi

# ------------------------------------------------------------------------------
# 3rd party add-ons. These are generally tacked on by the app in question...

# Direnv, nifty environment loading like rvmrc.
eval "$(direnv hook bash)"

# iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# NVM manage multiple versions of node/nvm.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# This is for serverless tab completion
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true


# Python virtualization layer(s)
# Use pyenv for python env management
eval "$(pyenv init -)"

# pipenv bash completions
eval "$(pipenv --completion)"

