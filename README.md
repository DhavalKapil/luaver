# Lua Version Manager - luaver

[![Join the chat at https://gitter.im/DhavalKapil/luaver](https://badges.gitter.im/DhavalKapil/luaver.svg)](https://gitter.im/DhavalKapil/luaver?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/DhavalKapil/luaver.svg?branch=master)](https://travis-ci.org/DhavalKapil/luaver)

Command line tool to manage and switch between different versions of lua, LuaJIT and luarocks.

## Features

1. Installs/Uninstalls any version of 'lua', 'LuaJIT' or 'luarocks' with a single command.
2. Switches between different versions of 'lua', 'LuaJIT' or 'luarocks' easily and without glitches.
3. Consistency between 'lua' and 'luarocks' maintained - Rocks and configurations for different lua versions are stored differently.

## Requirements

Requires `wget`, `make`.

You may need to install some dependencies:

```sh
sudo apt-get install libreadline-dev 
```

Also, if you are planning to install earlier versions of Lua(which are 32 bit) on 64 bit machines, you may need to install some 32 bit libraries first: 

```sh
sudo apt-get install lib32ncurses5-dev
```


## Installation

Run the following command to install

```sh
curl https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh -o install.sh && . ./install.sh
```

## Usage

### Sample usage:

```sh
luaver install 5.3.1             # Installs lua version 5.3.1
luaver install 5.3.0             # Installs lua version 5.3.0
luaver use 5.3.1                 # Switches to lua version 5.3.1
luaver install-luarocks 2.3.0    # Installs luarocks version 2.3.0
luaver uninstall 5.3.0           # Uninstalls lua version 5.3.0
```

### Complete usage:

```sh
luaver help

Usage:
   luaver help                              Displays this message
   luaver install <version>                 Installs lua-<version>
   luaver use <version>                     Switches to lua-<version>
   luaver set-default <version>             Sets <version> as default for lua
   luaver unset-default                     Unsets the default lua version
   luaver uninstall <version>               Uninstalls lua-<version>
   luaver list                              Lists installed lua versions
   luaver install-luajit <version>          Installs LuaJIT-<version>
   luaver use-luajit <version>              Switches to LuaJIT-<version>
   luaver set-default-luajit <version>      Sets <version> as default for LuaJIT
   luaver unset-default-luajit              Unsets the default LuaJIT version
   luaver uninstall-luajit <version>        Uninstalls LuaJIT-<version>
   luaver list-luajit                       Lists installed LuaJIT versions
   luaver install-luarocks <version>        Installs luarocks<version>
   luaver use-luarocks <version>            Switches to luarocks-<version>
   luaver set-default-luarocks <version>    Sets <version> as default for luarocks
   luaver unset-default-luarocks            Unsets the default luarocks version
   luaver uninstall-luarocks <version>      Uninstalls luarocks-<version>
   luaver list-luarocks                     Lists all installed luarocks versions
   luaver current                           Lists present versions being used
   luaver version                           Displays luaver version
```

## Contribution

Feel free to [file issues](https://github.com/DhavalKapil/luaver/issues) and submit [pull requests](https://github.com/DhavalKapil/luaver/pulls) – contributions are welcome.

## License

luaver is licensed under the [MIT license](http://dhaval.mit-license.org/).
