#!/bin/bash

# Directories to be used
LUAVM_DIR="${HOME}/.luavm"
SRC_DIR="${LUAVM_DIR}/src"
LUA_DIR="${LUAVM_DIR}/lua"

###############################################################################
# Helper functions

# Perform some initialization
init()
{
    if [ ! -e $LUAVM_DIR ]
    then
        mkdir $LUAVM_DIR
    fi

    if [ ! -e $SRC_DIR ]
    then
        mkdir $SRC_DIR
    fi

    if [ ! -e $LUA_DIR ]
    then
        mkdir $LUA_DIR
    fi
}

# Checking whether a particular tool exists or not
exists()
{
    type "$1" > /dev/null 2>&1
}

# Error handling function
error()
{
    echo "$1" 1>&2
    exit 1
}

# Downloads file from a url
download()
{
    local url=$1

    if exists "curl"
    then
        curl -R -O $url
    elif exists "wget"
    then
        wget $url
    else
        error "Either 'curl' or 'wget' must be installed"
    fi
}

# Unpacks an archive
unpack()
{
    if exists "tar"
    then
        tar xvzf $1
    else
        error "'tar' must be installed"
    fi
}

# Returns the platform
get_platform()
{
    local platform_str=$(uname | tr "[:upper:]" "[:lower:]")
    local platforms=("aix" "bsd" "c89" "freebsd" "generic" "linux" "macosx" "mingw" "posix" "solaris")

    for platform in "${platforms[@]}"
    do
        if [[ "${platform_str}" =~ "${platform}" ]]
        then
            eval "$1='$platform'"
            return
        fi
    done

    # Default platform
    eval "$1='linux'"
}

# End of Helper functions
###############################################################################

usage()
{
    :
}

install_lua()
{
    local version=$1
    local lua_dir_name="lua-${version}"
    local archive_name="${lua_dir_name}.tar.gz"
    local url="http://www.lua.org/ftp/${archive_name}"

    cd $SRC_DIR

    # Checking if archive already downloaded or not
    if [ -e $lua_dir_name ]
    then
        read -r -p "${lua_dir_name} has already been downloaded. Download again? [Y/n]: " choice
        case $choice in
            [yY][eE][sS] | [yY] )
                rm -r $lua_dir_name
                ;;
        esac 
    fi

    # Downloading the archive only if it does not exists"
    if [ ! -e $lua_dir_name ]
    then
        download $url
        unpack $archive_name
        rm $archive_name
    fi

    get_platform platform

    cd $lua_dir_name
    make $platform install INSTALL_TOP=$LUA_DIR/$version/
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

# Init environment
init

case $1 in
    "help" )         usage;;
    "install" )      install_lua ${@:2};;
    "use" )          use ${@:2};;
    "uninstall" )    uninstall_lua ${@:2};;
    "list" )         list;;
    "current" )      current;;
    "version" )      version;;
    * )              usage;;
esac