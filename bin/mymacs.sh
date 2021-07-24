#! /bin/bash

# Same as setup.sh, but it will not create the workspace...also it doesn't require the sandbox dir to exist.

cd
. ./.bash_profile

COMPANY=ellevation

function notify() {
    message="$1"
    # growlnotify -m "${message}"
    # terminal-notifier -title "Emacs"  -message "${message}" > /dev/null &
    osascript -e "display notification \"${message}\" with title \"Emacs\""
}


sandbox=$1
if [ -z "$sandbox" ] ; then
    notify "If you give me a sandbox name, I'll cd to that dir first."
    sandbox=main
    # exit 1
fi

notify "Setting up sandbox for work on '$sandbox'"

if [ -d ~/code ] ; then
    cd ~/code

    if [ -d $COMPANY/$sandbox ] ; then
        cd $COMPANY/$sandbox
    elif [ -d $sandbox ] ; then
        cd $sandbox
    fi
fi

nohup emacs --eval "(set-frame-name \"$sandbox\")" &

exit 0
