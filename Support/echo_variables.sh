#! /bin/bash

# Echoes back variables with names beginning with $1
for var in $(eval echo "\${!$1@}")
do
    echo "$var=${!var}"
done
