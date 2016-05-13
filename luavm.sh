#!/bin/bash

# Directories to be used
LUAVM_DIR="${HOME}/.luavm"      # The luavm directory
SRC_DIR="${LUAVM_DIR}/src"      # Where source code is downloaded and unpacked
LUA_DIR="${LUAVM_DIR}/lua"      # Where source is built
BIN_DIR="${LUAVM_DIR}/bin"      # Where binaries/soft links are present

###############################################################################
# Helper functions

# Error handling function
error()
{
    printf "$1\n" 1>&2
    exit 1
}

# Printing bold text - TODO
print()
{
    tput bold
    echo $1
    tput sgr0
}

# A wrapper function to execute commands on the terminal and exit on error
# Called whenever the execution should stop after any error occurs
exec_command()
{
    eval $1

    if [ ! $? -eq 0 ]
    then
        error "Unable to execute following command:\n$1\nExiting"
    fi
}

# Perform some initialization
init()
{
    if [ ! -e $LUAVM_DIR ]
    then
        exec_command "mkdir ${LUAVM_DIR}"
    fi

    if [ ! -e $SRC_DIR ]
    then
        exec_command "mkdir ${SRC_DIR}"
    fi

    if [ ! -e $LUA_DIR ]
    then
        exec_command "mkdir ${LUA_DIR}"
    fi

    if [ ! -e $BIN_DIR ]
    then
        exec_command "mkdir ${BIN_DIRs}"
    fi
}

# Checking whether a particular tool exists or not
exists()
{
    type "$1" > /dev/null 2>&1
}

# Downloads file from a url
download()
{
    local url=$1

    print "Downloading from ${url}"

    if exists "curl"
    then
        exec_command "curl -R -O ${url}"
    elif exists "wget"
    then
        exec_command "wget ${url}"
    else
        error "Either 'curl' or 'wget' must be installed"
    fi

    print "Download successfull"
}

# Unpacks an archive
unpack()
{
    print "Unpacking ${1}"

    if exists "tar"
    then
        exec_command "tar xvzf ${1}"
    else
        error "'tar' must be installed"
    fi

    print "Unpack successfull"
}

# Returns the platform
get_platform()
{
    local platform_str=$(uname | tr "[:upper:]" "[:lower:]")
    local platforms=("aix" "bsd" "c89" "freebsd" "generic" "linux" "macosx" "mingw" "posix" "solaris")

    print "Detecting platform"

    for platform in "${platforms[@]}"
    do
        if [[ "${platform_str}" =~ "${platform}" ]]
        then
            print "Platform detected: ${platform}"
            eval "$1='$platform'"
            return
        fi
    done

    # Default platform
    print "Unable to detect platform. Using default 'linux'"
    eval "$1='linux'"
}

# Returns the current version
get_current_version()
{
    local version=$(readlink $BIN_DIR/lua)

    version=${version#$LUA_DIR/}
    version=${version%/bin/lua}
    
    eval "$1='$version'"
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

    print "Installing ${lua_dir_name}"

    exec_command "cd ${SRC_DIR}"

    print "Detecting already downloaded archives"

    # Checking if archive already downloaded or not
    if [ -e $lua_dir_name ]
    then
        read -r -p "${lua_dir_name} has already been downloaded. Download again? [Y/n]: " choice
        case $choice in
            [yY][eE][sS] | [yY] )
                exec_command "rm -r ${lua_dir_name}"
                ;;
        esac 
    fi

    # Downloading the archive only if it does not exists"
    if [ ! -e $lua_dir_name ]
    then
        download $url
        unpack $archive_name
        exec_command "rm ${archive_name}"
    fi

    get_platform platform

    exec_command "cd ${lua_dir_name}"

    print "Compiling ${lua_dir_name}"

    exec_command "make ${platform} install INSTALL_TOP=${LUA_DIR}/${version}/"

    read -r -p "${lua_dir_name} successfully installed. Do you want to this version? [Y/n]: " choice
    case $choice in
        [yY][eE][sS] | [yY] )
            use $version
            ;;
    esac 
}

use()
{
    local version=$1
    local lua_name="lua-${version}"

    print "Switching to ${lua_name}"

    # Checking if this version exists
    exec_command "cd ${LUA_DIR}"

    if [ ! -e $version ]
    then
        read -r -p "${lua_name} is not installed. Want to install it? [Y/n]: " choice
        case $choice in
            [yY][eE][sS] | [yY] )
                install_lua $version
                ;;
            * )
                error "Unable to use ${lua_name}"
        esac
        return
    fi

    exec_command "cd ${BIN_DIR}"
    if [ -L "lua" ]
    then
        exec_command "rm lua"
    fi

    exec_command 'ln -s "${LUA_DIR}/${version}/bin/lua"'

    print "Successfully switched to ${lua_name}"
}

uninstall_lua()
{
    local version=$1
    local lua_name="lua-${version}"

    print "Uninstalling ${lua_name}"

    exec_command "cd ${LUA_DIR}"
    if [ ! -e "${version}" ]
    then
        error "${lua_name} is not installed"
    fi

    exec_command 'rm -r "${version}"'

    print "Successfully uninstalled ${lua_name}"
}

list()
{
    installed_versions=($(ls $LUA_DIR/))
    get_current_version current_version

    print "Installed versions: "
    for version in "${installed_versions[@]}"
    do
        if [ "${version}" == "${current_version}" ]
        then
            print "lua-${version} <--"
        else 
            print "lua-${version}"
        fi
    done
}

current()
{
    get_current_version current_version

    print "Current versionsersion:"
    print "lua-${current_version}"
}

version()
{
    :
}

# Init environment
init

case $1 in
    "help" )                usage;;
    "install" )             install_lua ${@:2};;
    "use" )                 use ${@:2};;
    "uninstall" )           uninstall_lua ${@:2};;
    "list" )                list;;
    "current" )             current;;
    "version" )             version;;
    * )                     usage;;
esac
    