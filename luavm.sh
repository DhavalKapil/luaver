#!/bin/bash

# Directories to be used
LUAVM_DIR="${HOME}/.luavm"              # The luavm directory
SRC_DIR="${LUAVM_DIR}/src"              # Where source code is downloaded
LUA_DIR="${LUAVM_DIR}/lua"              # Where lua source is built
LUAROCKS_DIR="${LUAVM_DIR}/luarocks"    # Where luarocks source is built
BIN_DIR="${LUAVM_DIR}/bin"              # Where binaries/soft links are present

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

    if [ ! -e $LUAROCKS_DIR ]
    then
        exec_command "mkdir ${LUAROCKS_DIR}"
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

    if exists "wget"
    then
        exec_command "wget ${url}"
    else
        error "'wget' must be installed"
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

# Downloads and unpacks an archive
download_and_unpack()
{
    local unpack_dir_name=$1
    local archive_name=$2
    local url=$3

    print "Detecting already downloaded archives"

    # Checking if archive already downloaded or not
    if [ -e $unpack_dir_name ]
    then
        read -r -p "${unpack_dir_name} has already been downloaded. Download again? [Y/n]: " choice
        case $choice in
            [yY][eE][sS] | [yY] )
                exec_command "rm -r ${unpack_dir_name}"
                ;;
        esac
    fi

    # Downloading the archive only if it does not exists"
    if [ ! -e $unpack_dir_name ]
    then
        print "Downloading ${unpack_dir_name}"
        download $url
        print "Extracting archive"
        unpack $archive_name
        exec_command "rm ${archive_name}"
    fi
}

# Uninstalls lua/luarocks
uninstall()
{
    local package_name=$1
    local package_path=$2
    local package_dir=$3

    print "Uninstalling ${package_name}"

    exec_command "cd ${package_path}"
    if [ ! -e "${package_dir}" ]
    then
        error "${package_name} is not installed"
    fi

    exec_command 'rm -r "${package_dir}"'

    print "Successfully uninstalled ${package_name}"
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
get_current_lua_version()
{
    local version=$(readlink $BIN_DIR/lua)

    version=${version#$LUA_DIR/}
    version=${version%/bin/lua}
    
    eval "$1='$version'"
}

# Returns the current lua version (only the first two numbers)
get_current_lua_version_short()
{
    local version=$(${BIN_DIR}/lua -e 'print(_VERSION:sub(5))')

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

    download_and_unpack $lua_dir_name $archive_name $url

    get_platform platform

    exec_command "cd ${lua_dir_name}"

    print "Compiling ${lua_dir_name}"

    exec_command "make ${platform} install INSTALL_TOP=${LUA_DIR}/${version}/"

    read -r -p "${lua_dir_name} successfully installed. Do you want to this version? [Y/n]: " choice
    case $choice in
        [yY][eE][sS] | [yY] )
            use_lua $version
            ;;
    esac 
}

use_lua()
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
    if [ -L "luac" ]
    then
        exec_command "rm luac"
    fi

    exec_command 'ln -s "${LUA_DIR}/${version}/bin/lua"'
    exec_command 'ln -s "${LUA_DIR}/${version}/bin/luac"'

    print "Successfully switched to ${lua_name}"
}

uninstall_lua()
{
    local version=$1
    local lua_name="lua-${version}"

    uninstall $lua_name $LUA_DIR $version
}

list_lua()
{
    installed_versions=($(ls $LUA_DIR/))
    get_current_lua_version current_version

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

install_luarocks()
{
    # Checking whether any version of lua is installed or not
    get_current_lua_version lua_version
    if [ "" == "${lua_version}" ]
    then
        error "No lua version set"
    fi

    get_current_lua_version_short lua_version_short

    local version=$1
    local luarocks_dir_name="luarocks-${version}"
    local archive_name="${luarocks_dir_name}.tar.gz"
    local url="http://luarocks.org/releases/${archive_name}"

    print "Installing ${luarocks_dir_name} for lua version ${lua_version}"

    exec_command "cd ${SRC_DIR}"

    download_and_unpack $luarocks_dir_name $archive_name $url

    exec_command "cd ${luarocks_dir_name}"

    print "Compiling ${luarocks_dir_name}"

    exec_command "./configure
                    --prefix=${LUAROCKS_DIR}/${version}_${lua_version_short}
                    --with-lua=${LUA_DIR}/${lua_version}
                    --with-lua-bin=${LUA_DIR}/${lua_version}/bin
                    --with-lua-include=${LUA_DIR}/${lua_version}/include
                    --with-lua-lib=${LUA_DIR}/${lua_version}/lib
                    --versioned-rocks-dir"

    exec_command "make build"
    exec_command "make install"

    read -r -p "${luarocks_dir_name} successfully installed. Do you want to this version? [Y/n]: " choice
    case $choice in
        [yY][eE][sS] | [yY] )
            use_luarocks $version
            ;;
    esac
}

use_luarocks()
{

    local version=$1
    local luarocks_name="luarocks-${version}"

    get_current_lua_version_short lua_version

    print "Switching to ${luarocks_name} with lua version: ${lua_version}"

    # Checking if this version exists
    exec_command "cd ${LUAROCKS_DIR}"

    if [ ! -e "${version}_${lua_version}" ]
    then
        read -r -p "${luarocks_name} is not installed with lua version ${lua_version}. Want to install it? [Y/n]: " choice
        case $choice in
            [yY][eE][sS] | [yY] )
                install_luarocks $version
                ;;
            * )
                error "Unable to use ${luarocks_name}"
        esac
        return
    fi

    exec_command "cd ${BIN_DIR}"
    if [ -L "luarocks" ]
    then
        exec_command "rm luarocks"
    fi
    if [ -L "luarocks-admin" ]
    then
        exec_command "rm luarocks-admin"
    fi

    exec_command 'ln -s "${LUAROCKS_DIR}/${version}_${lua_version}/bin/luarocks"'
    exec_command 'ln -s "${LUAROCKS_DIR}/${version}_${lua_version}/bin/luarocks-admin"'

    print "Successfully switched to ${luarocks_name}"
}

uninstall_luarocks()
{
    local version=$1
    local luarocks_name="luarocks-${version}"

    get_current_lua_version_short lua_version

    uninstall $luarocks_name $LUAROCKS_DIR "${version}_${lua_version}"
}

current()
{
    get_current_lua_version lua_version

    print "Current version:"
    print "lua-${lua_version}"
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
    "use" )                 use_lua ${@:2};;
    "uninstall" )           uninstall_lua ${@:2};;
    "list" )                list_lua;;

    "install-luarocks")     install_luarocks ${@:2};;
    "use-luarocks" )        use_luarocks ${@:2};;
    "uninstall-luarocks" )  uninstall_luarocks ${@:2};;
    "list-luarocks" )       list_luarocks;;

    "current" )             current;;
    "version" )             version;;
    * )                     usage;;
esac
    