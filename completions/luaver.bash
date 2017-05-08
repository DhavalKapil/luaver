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
                    declare -a _luaver_lua_versions
                    if [ -z "$_luaver_lua_versions" ]
                    then
                        _luaver_lua_versions=($(_luaver_download 'https://www.lua.org/ftp/' | sed -n -e 's/.*lua\-\(5\.[0-9]\.[0-9]\)\.tar\.gz.*/\1/gp'))
                    fi
                    opts=(${_luaver_lua_versions[@]})
                    ;;
                install-luajit )
                    if [ -z "$_luaver_luajit_versions" ]
                    then
                        _luaver_luajit_versions=($(_luaver_download "http://luajit.org/download.html" | awk '/MD5 Checksums/,/<\/pre/ { print }' | sed -n -e 's/.*LuaJIT-\(.*\)\.tar\.gz.*/\1/gp'))
                    fi
                    opts=(${_luaver_luajit_versions[@]})
                    ;;
                install-luarocks )
                    if [ -z "$_luaver_luarocks_versions" ]
                    then
                        _luaver_luarocks_versions=($(_luaver_download 'http://luarocks.github.io/luarocks/releases/releases.json' | sed -n -e 's/.*luarocks-\(.*\)\.tar\.gz.*/\1/gp'))
                    fi
                    opts=(${_luaver_luarocks_versions[@]})
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
