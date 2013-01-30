#!/bin/bash

testname="${DJANGO_ALL_TESTS:-}"
if [ $1 ]; then
    testname=$(python "$TM_BUNDLE_SUPPORT/testing.py" $1)

    if [[ $testname =~ Error\: ]]; then
        echo $testname
        exit 1
    fi
fi


source "$TM_BUNDLE_SUPPORT/activate_env.sh"

resourcedir="file:///$TM_BUNDLE_SUPPORT/resource"

read -r -d '' output <<HTML
<html>
<head>
    <title>Testing $testname</title>
    <link rel="stylesheet" href="$resourcedir/test.css" type="text/css" />
    <script type="text/javascript" src="$resourcedir/jquery-1.9.0.min.js"></script>
    <script type="text/javascript" src="$resourcedir/test.js"></script>
</head>
<body>
    <code><pre>
HTML
echo $output

python -u manage.py test $testname --settings=$DJANGO_SETTINGS_MODULE 2>&1

read -r -d '' output <<HTML
    </pre></code>
</body></html>
HTML

exit 0
