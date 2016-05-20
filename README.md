# Lua Version Manager - luavm

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
curl https://raw.githubusercontent.com/DhavalKapil/luavm/master/install.sh | . ./install.sh
```

## Usage

### Sample usage:

```sh
luavm install 5.3.1             # Installs lua version 5.3.1
luavm install 5.3.0             # Installs lua version 5.3.0
luavm use 5.3.1                 # Switches to lua version 5.3.1
luavm install-luarocks 2.3.0    # Installs luarocks version 2.3.0
luavm uninstall 5.3.0           # Uninstalls lua version 5.3.0
```

### Complete usage:

```sh
luavm help

Usage:
   luavm help                          Displays this message
   luavm install <version>             Installs lua-<version>
   luavm use <version>                 Switches to lua-<version>
   luavm uninstall <version>           Uninstalls lua-<version>
   luavm list                          Lists installed lua versions
   luavm install-luajit <version>      Installs LuaJIT-<version>
   luavm use-luajit <version>          Switches to LuaJIT-<version>
   luavm uninstall-luajit <version>    Uninstalls LuaJIT-<version>
   luavm list-luajit                   Lists installed LuaJIT versions
   luavm install-luarocks <version>    Installs luarocks<version>
   luavm use-luarocks <version>        Switches to luarocks-<version>
   luavm uninstall-luarocks <version>  Uninstalls luarocks-<version>
   luavm list-luarocks                 Lists all installed luarocks versions
   luavm current                       Lists present versions being used
   luavm version                       Displays luavm version
```

## Contribution

Feel free to [file issues](https://github.com/DhavalKapil/luavm/issues) and submit [pull requests](https://github.com/DhavalKapil/luavm/pulls) – contributions are welcome.

## License

luavm is licensed under the [MIT license](http://dhaval.mit-license.org/).
