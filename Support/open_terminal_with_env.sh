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

osascript <<-APPLESCRIPT
	tell app "Terminal"
	    activate
        tell application "System Events"
            keystroke "t" using {command down}
        end tell
	    do script "cd $(esc "${TM_PROJECT_DIRECTORY}")" in window 0
        do script "VIRTUALENV=$VIRTUALENV VIRTUALENVWRAPPER=$VIRTUALENVWRAPPER source '$TM_BUNDLE_SUPPORT/activate_env.sh'" in window 0
        do script "$("$TM_BUNDLE_SUPPORT"/export_variables.sh $EXPORT_VARIABLES_TO_TERMINAL)" in window 0
        do script "clear" in window 0
	end tell
APPLESCRIPT
"$TM_BUNDLE_SUPPORT"/clear_scrollback.sh
