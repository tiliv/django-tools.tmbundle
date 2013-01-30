#! /bin/bash

if [ $VIRTUALENVWRAPPER ]; then
    workon ${VIRTUALENVWRAPPER}
elif [ $VIRTUALENV ]; then
    source ${VIRTUALENV}/bin/activate
fi
