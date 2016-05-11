#!/bin/bash

usage()
{
    :
}

install_lua()
{
    :
}

use()
{
    :
}

uninstall_lua()
{
    :
}

list()
{
    :
}

current()
{
    :
}

version()
{
    :
}

case $1 in
    'help' )         usage;;
    'install' )      install_lua ${@:2};;
    'use' )          use ${@:2};;
    'uninstall' )    uninstall_lua ${@:2};;
    'list' )         list;;
    'current' )      current;;
    'version' )      version;;
    * )              usage;;
esac