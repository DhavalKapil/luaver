#!/bin/bash

PROGRAM="luavm"
SRC_URL="https://raw.githubusercontent.com/DhavalKapil/luavm/master/${PROGRAM}"

# Directories to be used
LUAVM_DIR="${HOME}/.luavm"              # The luavm directory
SRC_DIR="${LUAVM_DIR}/src"              # Where source code is downloaded
LUA_DIR="${LUAVM_DIR}/lua"              # Where lua source is built
LUAJIT_DIR="${LUAVM_DIR}/luajit"        # Where luajit source is built
LUAROCKS_DIR="${LUAVM_DIR}/luarocks"    # Where luarocks source is built
BIN_DIR="${LUAVM_DIR}/bin"              # Where binaries/soft links are present

# Initializes directories

# Printing bold text - TODO
print()
{
    tput bold
    echo $1
    tput sgr0
}

init()
{
    print "Setting up directory structure..."
    
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
    if [ ! -e $LUAJIT_DIR ]
    then
        mkdir $LUAJIT_DIR
    fi
    if [ ! -e $LUAROCKS_DIR ]
    then
        mkdir $LUAROCKS_DIR
    fi
    if [ ! -e $BIN_DIR ]
    then
        mkdir $BIN_DIR
    fi
    print "Directory structure built..."
}

# Downloads luavm
install()
{
    print "Downloading '${PROGRAM}'..."
    cd $BIN_DIR
    if [ -e $PROGRAM ]
    then
        print "Existing '${PROGRAM}' detected. Removing it..."
        rm $PROGRAM
        print "Downloading fresh '${PROGRAM}'"
    fi
        
    wget $SRC_URL
    chmod 775 $PROGRAM
}

# Inserts path variables inside bash rc
set_up_path()
{
    local str="export PATH=\"${BIN_DIR}:${PATH}\""
    local shell_type="$(basename $SHELL)"
    print "Detected SHELL_TYPE: ${shell_type}"
    
    local profile=""
    if [ "${shell_type}" == "bash" ]
    then
        if [ -f "$HOME/.bashrc" ]
        then
            profile="$HOME/.bashrc"
        fi
    elif [ "shell_type" = "zsh" ]
    then
        if [ -f "$HOME/.zshrc" ]
        then
            profile="$HOME/.zshrc"
        fi
    fi
    
    if [ "${profile}" == "" ]
    then
        print "Unable to detect profile(no ~/.bashrc, ~/.zshrc found)"
        print "Add the following at the end of the correct file yourself:"
        print "${str}"
        print "PLease file an issue for this on the github repository"
    else
        if ! command grep -qc "${str}" "${profile}"
        then
            print "Appending '${str}' at the end of ${profile}"
            printf "\n${str}\n" >> $profile
            print "You can start using it in a new terminal or run 'source ~/.bashrc' in present terminal"
        fi
    fi
}

print "Installing '${PROGRAM}'..."
init
install
set_up_path
print "Successfully installed '${PROGRAM}'..."
