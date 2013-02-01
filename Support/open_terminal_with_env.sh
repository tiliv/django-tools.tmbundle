#! /bin/bash

# Borrowed from the built-in support scripts
esc () {
STR="$1" ruby <<"RUBY"
   str = ENV['STR']
   str = str.gsub(/'/, "'\\\\''")
   str = str.gsub(/[\\"]/, '\\\\\\0')
   print "'#{str}'"
RUBY
}

osascript <<- APPLESCRIPT
	tell app "Terminal"
	    launch
	    activate
	    do script "cd $(esc "${TM_PROJECT_DIRECTORY}")"
        do script "VIRTUALENV=$VIRTUALENV VIRTUALENVWRAPPER=$VIRUALENVWRAPPER source '$TM_BUNDLE_SUPPORT/activate_env.sh'" in window 0
        do script "clear" in window 0
	end tell
APPLESCRIPT
"$TM_BUNDLE_SUPPORT"/clear_scrollback.sh
