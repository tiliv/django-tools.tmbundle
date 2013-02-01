#!/bin/bash

"$TM_BUNDLE_SUPPORT"/open_terminal_with_env.sh
osascript <<- APPLESCRIPT
    tell app "Terminal"
        delay 0.1
        do script "./manage.py $1 --settings=$DJANGO_SETTINGS_MODULE" in window 0
    end tell
APPLESCRIPT
"$TM_BUNDLE_SUPPORT"/clear_scrollback.sh
