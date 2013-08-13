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
    compgen -v | egrep $1 | while read var; do echo "export $var=$(esc "${!var}")"; done
fi
