#!/bin/sh

set -eu

for f in *_test.sh
do
    if [ "x$SHELL" = xzsh ]
    then
        zsh -y -- "$f" 
    else
        "$SHELL" "$f"
    fi
done