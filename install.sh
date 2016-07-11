PROGRAM="luaver"
SRC_URL="https://raw.githubusercontent.com/dhavalkapil/luaver/v1.0.0/${PROGRAM}"

# Directories to be used
LUAVER_DIR="${HOME}/.luaver"             # The luaver directory
SRC_DIR="${LUAVER_DIR}/src"              # Where source code is downloaded
LUA_DIR="${LUAVER_DIR}/lua"              # Where lua source is built
LUAJIT_DIR="${LUAVER_DIR}/luajit"        # Where luajit source is built
LUAROCKS_DIR="${LUAVER_DIR}/luarocks"    # Where luarocks source is built

# Present directory
present_dir=$(pwd)

# Printing bold text - TODO
print()
{
    tput bold
    printf "==>  $1\n"
    tput sgr0
}

# Initializes directories
init()
{
    print "Setting up directory structure..."
    
    if [ ! -e $LUAVER_DIR ]
    then
        mkdir $LUAVER_DIR
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
    print "Directory structure built..."
}

# Downloads luaver
install()
{
    print "Downloading '${PROGRAM}'..."
    cd $LUAVER_DIR
    if [ -e $PROGRAM ]
    then
        print "Existing '${PROGRAM}' detected. Removing it..."
        rm $PROGRAM
        print "Downloading fresh '${PROGRAM}'"
    fi
    if [ "${__luaver_env}" = "testing" ]
    then
        cd $present_dir
        cp "./${PROGRAM}" "${LUAVER_DIR}/"
        cd $LUAVER_DIR
    else
        wget $SRC_URL
    fi
    chmod 775 $PROGRAM
}

# Inserts path variables inside bash rc
set_up_path()
{
    local str="[ -s ${LUAVER_DIR}/${PROGRAM} ] && . ${LUAVER_DIR}/${PROGRAM}"
    local shell_type="$(basename $SHELL)"
    print "Detected SHELL_TYPE: ${shell_type}"
    
    local profile=""
    if [ "${shell_type}" = "bash" ]
    then
        if [ -f "$HOME/.bashrc" ]
        then
            profile="$HOME/.bashrc"
        fi
    elif [ "${shell_type}" = "zsh" ]
    then
        if [ -f "$HOME/.zshrc" ]
        then
            profile="$HOME/.zshrc"
        fi
    fi
    
    if [ "${profile}" = "" ]
    then
        print "Unable to detect profile(no ~/.bashrc, ~/.zshrc found)"
        print "Add the following at the end of the correct file yourself:"
        print "${str}"
        print "You can start using it in a new terminal or run 'source ~/.bashrc' in present terminal"
    else
        if ! command grep -qc "${str}" "${profile}"
        then
            print "Appending '${str}' at the end of ${profile}"
            printf "\n${str}\n" >> $profile
        fi
        source $profile
    fi
    pwd
    cd $present_dir
    pwd
}

print "Installing '${PROGRAM}'..."
init
install
set_up_path
print "Successfully installed '${PROGRAM}'..."
