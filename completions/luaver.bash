#!/bin/bash

_luaver_download()
{
    if curl -V >/dev/null 2>&1
    then
        curl -fsSL "$1"
    else
        wget -qO- "$1"
    fi
}

_luaver()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts
    case $COMP_CWORD in
        1 )
            opts=($(luaver help | 'awk' '/^   / { print $2 }')) # UGLY HACK
            ;;
        2 )
            case ${COMP_WORDS[COMP_CWORD-1]} in
                install )
                    opts=($(_luaver_download "https://www.lua.org/ftp/" | 'awk' 'match($0, /lua-5\.[0-9]+(\.[0-9]+)?/) { print substr($0, RSTART + 4, RLENGTH - 4) }'))
                    ;;
                install-luajit )
                    opts=($(_luaver_download "http://luajit.org/download.html" | awk '/MD5 Checksums/,/<\/pre/ { print }' | awk '/LuaJIT.*gz/ { print $2 }' | sed -e s/LuaJIT-// -e s/\.tar\.gz//))
                    ;;
                install-luarocks )
                    opts=($(wget -qO- http://luarocks.github.io/luarocks/releases/releases.json | 'awk' 'match($0, /"[0-9]+\.[0-9]\.[0-9]"/) { print substr($0, RSTART, RLENGTH) } '))
                    ;;
                use | set-default | uninstall)
                    opts=($(luaver list | grep '[0-9].[0-9].[0-9]' | tr - ' ')) # UGLY HACK
                    ;;
                use-luajit | set-default-luajit | uninstall-luajit )
                    opts=($(luaver list-luajit | grep '[0-9].[0-9].[0-9]' | tr - ' ')) # UGLY HACK
                    ;;
                use-luarocks | set-default-luarocks | uninstall-luarocks)
                    opts=($(luaver list-luarocks | grep '[0-9].[0-9].[0-9]' | tr - ' ')) # UGLY HACK
                    ;;
            esac
            ;;
    esac
    COMPREPLY=($(compgen -W "${opts[*]}" -- "$cur"))
}

complete -F _luaver luaver
