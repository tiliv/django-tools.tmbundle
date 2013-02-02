#! /bin/bash

if [ $VIRTUALENVWRAPPER ]; then
    source virtualenvwrapper.sh
    workon ${VIRTUALENVWRAPPER}
elif [ $VIRTUALENV ]; then
    source ${VIRTUALENV}/bin/activate
fi
