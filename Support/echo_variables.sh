#! /bin/bash

esc () {
STR="$1" ruby <<"RUBY"
   str = ENV['STR']
   str = str.gsub(/'/, "'\\\\''")
   str = str.gsub(/[\\"]/, '\\\\\\0')
   print "'#{str}'"
RUBY
}

if [ $1 ]; then
    # Echoes back variables with names beginning with $1
    for var in $(eval echo "\${!$1@}")
    do
        echo "$var=$(esc "${!var}")"
    done
fi
