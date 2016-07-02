#!/bin/bash

. ~/.luaver/luaver

# Confirming default lua version
version_string=$(lua -v)
if test "${version_string#*5.2.4}" == "${version_string}"
then
    exit 1
fi

# Confirming
version_string=$(luarocks)
if test "${version_string#*2.3.0}" == "${version_string}"
then
    exit 1
fi
