#! -*- shell-script -*-

# ------------------------------------------------------------------------------
# My .bash_profile
#
# See also, my .bashrc file (some duplicative stuff most likely)

# No need to export some of these, we only need them here.

IS_INTERACTIVE=false
if [ "$TERM" != dumb ] ; then
    IS_INTERACTIVE=true
fi

IS_WINDOWS=false
if [ "$(uname)" = CYGWIN* ] ; then
    IS_WINDOWS=true
fi

# ------------------------------------------------------------------------------
# Some helper functions we'll use in here only (mostly likely)

function initialization_message {
    if [ "$IS_INTERACTIVE" = true ] ; then
        echo "$@"
    else
        # Do nothing
        :
    fi
}

initialization_message "Loading .bash_profile..."

# ------------------------------------------------------------------------------
# Some functions I find useful
#
# Many of these I've replaced with custom scripts in my ~/bin directory
#

if [ "$IS_INTERACTIVE" = true ] ; then

    initialization_message "  -Functions"

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

fi

# ------------------------------------------------------------------------------
# Aliases

if [ "$IS_INTERACTIVE" = true ] ; then

    initialization_message "  -Aliases"

    # alias foo="git status"

    # Relies on saml2aws setup
    # alias aws-dev="saml2aws console -a dev && saml2aws login -a dev"
    # alias aws-prod="saml2aws console -a prod && saml2aws login -a prod"
    # alias aws-feature="saml2aws console -a feature && saml2aws login -a feature"
    alias aws-unset="unset AWS_PROFILE AWS_REGION"
    alias aws-dev="export AWS_PROFILE=dev AWS_REGION=us-east-1 && aws configure list &> /dev/null || aws sso login"
    alias aws-prod="export AWS_PROFILE=prod AWS_REGION=us-east-1 && aws configure list &> /dev/null || aws sso login"
    alias aws-?="echo AWS_PROFILE=${AWS_PROFILE:-unset}"

    # wireguard vpn
    alias vpn-up="wg-quick up wg0"
    alias vpn-down="wg-quick down wg0"

    # alias rptw="./run.sh pytest -s -vv --looponfail"
    alias pr='poetry run'
    alias prp='poetry run poe'


fi

# ------------------------------------------------------------------------------
# Path setup

initialization_message "  -Path"
export PATH_SEP=:
if [ "$IS_WINDOWS" = true ] ; then
    PATH_SEP=;
fi
function add-to-path {
    export PATH="${1}${PATH_SEP}${PATH}"
}

# Save off the path for safe keeping
export OS_PATH="$PATH"

if [ "$IS_WINDOWS" = true ] ; then
    # TODO: set a default path?
    :
elif [ -f /opt/homebrew/bin/brew ] ; then
    # Let homebrew set up our path
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Dunno...at this point, not sure what to add on?
    :
fi

# Add some of my stuff
add-to-path ~/bin-private
add-to-path ~/bin

# VS Code
add-to-path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# This is where pipx puts things
add-to-path ~/.local/bin

# Elastic Beanstalk CLI
# (https://github.com/aws/aws-elastic-beanstalk-cli-setup)
# add-to-path ~/.ebcli-virtual-env/executables

# If my job has tools
if [ -e ~/code/job/main/tools/bin ] ; then
    add-to-path ~/code/job/main/tools/bin
fi

# If we installed ruby
if [ -d /opt/homebrew/opt/ruby/bin ] ; then
    add-to-path /opt/homebrew/opt/ruby/bin
fi

# For my sql emacs layer - to format sql code...had to jump through some hoops to get this installed
# on my work laptop, but finally got it.
if [ -e ~/code/misc/sqlfmt/backend/dist/sqlfmt_darwin_amd64_v1/sqlfmt ] ; then
    add-to-path ~/code/misc/sqlfmt/backend/dist/sqlfmt_darwin_amd64_v1/
fi

# ------------------------------------------------------------------------------
# Completions (not all of them, just mine and homebrew ones)

if [ "$IS_INTERACTIVE" = true ] ; then
    initialization_message "  -Bash Completions"

    # Homebrew completions
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

    # Completions for screen wrapper (complete with hosts in known_hosts)
    complete -F _known_hosts scr

    # AWS cli
    if [ -f "/opt/homebrew/bin/aws_completer" ] ; then
        complete -C '/opt/homebrew/bin/aws_completer' aws
    fi

    # saml2aws
    if command -v saml2aws 1>/dev/null 2>&1
    then
        eval "$(saml2aws --completion-script-bash)"
    fi

fi  # interactive? install completions


# ------------------------------------------------------------------------------
# PS1 prompt

if [ "$IS_INTERACTIVE" = true ] ; then
    #PS1='\h:\W$(__git_ps1 "(%s)") \u\$ '

    # Tried this, but it seemed to break
    #PS1='[\e[1;33m\w\e[m\e[3;32m$(__git_ps1 "(git-%s)")\e[m]$ '

    # This is sam's; he's had luck with it.
    # Green user@host, Blue directory $ (optional git branch info)
    # PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(__git_ps1 "\[\033[01;33m\](%s)")\[\033[00m\]$ '

    # Trying this one out:
    # [\e[0m\] clears out previous formatting
    # Any non-printable codes (color/formatting) must be wrapped in \[ and \]
    #
    # - optional prefix as set by direnv (in light gray 37)
    #   Direnv doesn't support setting PS1, so use this trick to enable it via env vars
    #   see: https://github.com/direnv/direnv/wiki/PS1
    PS1='${DIRENV_PS1:+\[\e[01;37m\]($DIRENV_PS1)\e[0m\]}'
    # - light yellow (93) History number (\!) in square brackets
    PS1=$PS1'\[\e[01;93m\][\!]\[\e[0m\]'
    # - (skipping for now) light red (91) Exit code ($?) in parens
    # - light green (92) user (\u) followed by colon
    PS1=$PS1'\[\e[01;92m\]\u:\[\e[0m\]'
    # - light blue (94) directory (\w)
    PS1=$PS1'\[\e[01;94m\]\w\[\e[0m\]'
    #
    # - light yellow (93) git PS1 status wrapped in parens (if git bash prompt helpers are installed)
    if [[ $(type -t __git_ps1) == function ]] ; then
        PS1=$PS1'$(__git_ps1 "\[\e[01;93m\](%s)")\[\e[0m\]'
    fi
    # Lastly...the prompt
    PS1=$PS1'$ '
else

    PS1='[\w$(__git_ps1 "(git-%s)")]$ '
    #PS1='\s-\v\$ '

    # Also for git on dumb terms, less is not a good thing...use cat instead
    # Not sure why this is in here or if I still need it...right now PAGER is
    # unset so I'm guessing it defaults to less? Still, gonna axe this for now
    # and bring it back if I need it.
    # export PAGER=cat
fi

# ------------------------------------------------------------------------------
# Misc exports to control behavior of various things

# Tell Homebrew not to auto-update anytime you run a brew install command
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Tell mac tar to not put the garbage in tarballs that messes with real unix systems.
# http://www.unwin.org/solr_error_in_opening_zip_file.html
export COPYFILE_DISABLE=true

# Save unified history
# http://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals
export PROMPT_COMMAND_HISTORY='history -a'

# Before we get too far, let's set PROMPT_COMMAND as others may set it below
export PROMPT_COMMAND="${PROMPT_COMMAND_HISTORY}"

# Java

if /usr/libexec/java_home --failfast 1> /dev/null 2>&1
then
    initialization_message "  -Initializing Java"
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi

# Postgres (need this to be able to use psql to connect to a docker running pg
# instance)
# export PGHOST=127.0.0.1
# export PGUSER=diesel
# PG no longer puts itself in path...multiple versions I guess.
if [ -f /opt/homebrew/opt/postgresql@15/bin/psql ] ; then
    add-to-path /opt/homebrew/opt/postgresql@15/bin
fi

# Building the python psycopg library doesn't work with brew ssl for some reason
# out of the box. Need to specify some additional args
export LDFLAGS="${LDFLAGS} -I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"

# Editor
# At times I've set this to a script I keep in bin, but for the most part, emacs
# is running, so no need
export EDITOR=emacsclient

# Silence the MacOS bash is replaced with zsh message
export BASH_SILENCE_DEPRECATION_WARNING=1

# ------------------------------------------------------------------------------
# Misc other sourcing

# If there is a file with myget creds, let's source it. Kinda evil to have these
# floating around, but better than littering each repo with a .env file with the
# creds in them, IMO.
#
# Temporarily set -a so they're auto-exported too.
if [ -f ~/.myget-credentials ] ; then
    set -a
    source ~/.myget-credentials
    set +a
fi

# Direnv, nifty environment loading like rvmrc.
if command -v direnv 1>/dev/null 2>&1
then
    initialization_message "  -direnv"
    eval "$(direnv hook bash)"
fi

# iTerm shell integration
if [ -e "${HOME}/.iterm2_shell_integration.bash" ] ; then
    initialization_message "  -iTerm2 shell integration"
    source "${HOME}/.iterm2_shell_integration.bash"
fi

# NVM manage multiple versions of node/nvm.
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] ; then
    initialization_message "  -nvm"
    source "/opt/homebrew/opt/nvm/nvm.sh"
    if [ "$IS_INTERACTIVE" = true ] && [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] ; then
        # initialization_message "    -completions"
        source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    fi
fi

# Serverless (completions only)
if [ "$IS_INTERACTIVE" = true ] && [ -f ~/.config/tabtab/__tabtab.bash ] ; then
    initialization_message "  -serverless"
    source ~/.config/tabtab/__tabtab.bash
fi

# Python pyenv for managing multiple python versions
if command -v pyenv 1>/dev/null 2>&1; then
    initialization_message "  -pyenv"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Update link/compile flags when using unixodbc
if [ -e /opt/homebrew/Cellar/unixodbc ] ; then
    initialization_message "  -unixodbc link/compile flags"
    export LDFLAGS="${LDFLAGS} -L/opt/homebrew/Cellar/unixodbc/2.3.9_1/lib"
    export CPPFLAGS="${CPPFLAGS} -I/opt/homebrew/Cellar/unixodbc/2.3.9_1/include"
fi

# pipenv bash completions (disabled in favor of poetry for now)
# cannot enable this until this issue is resolved:
# https://github.com/pypa/pipenv/issues/4872
# initialization_message "Initializing pipenv"
# eval "$(_PIPENV_COMPLETE=bash_source pipenv)"

# Poetry (python dependency management stuff)
if command -v poetry 1>/dev/null 2>&1 && [ "$IS_INTERACTIVE" = true ] ; then
    initialization_message "  -poetry"
    eval "$(poetry completions bash)"
fi
# Set a custom poetry config location
if [ -f ~/code/personal/config/dot/Library/Preferences/poetry/config.toml ] ; then
    export POETRY_CONFIG_DIR=~/code/personal/config/dot/Library/Preferences/poetry
fi

# GitHub CLI 1Password integration
if [ -f ~/.config/op/plugins.sh ]
then
    initialization_message "  -GitHub CLI"
    source /Users/justinmills/.config/op/plugins.sh
fi
