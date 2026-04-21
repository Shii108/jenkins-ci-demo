#!/bin/bash

./app.sh > output.txt

if [ $? -eq 0 ]; then
    echo "PASS: app.sh ran successfully"
else
    echo "FAIL: app.sh did not run"
    exit 1
fi

grep "Hostname" output.txt > /dev/null

if [ $? -eq 0 ]; then
    echo "PASS: Output contains hostname"
else
    echo "FAIL: Output missing hostname"
    exit 1
fi
