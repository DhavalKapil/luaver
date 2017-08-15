# Lua Version Manager - luaver

[![Build Status](https://travis-ci.org/DhavalKapil/luaver.svg?branch=master)](https://travis-ci.org/DhavalKapil/luaver) [![Join the chat at https://gitter.im/DhavalKapil/luaver](https://badges.gitter.im/DhavalKapil/luaver.svg)](https://gitter.im/DhavalKapil/luaver?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE.md)

**luaver** helps to manage and switch between different versions of Lua, LuaJIT and Luarocks.

## Features

1. Installs/Uninstalls any version of Lua, LuaJIT or luarocks with a single command.
2. Switches between different versions of 'Lua', 'LuaJIT' or 'Luarocks' easily, without glitches.
3. Consistency between 'Lua' and 'Luarocks' maintained - Rocks and configurations for different lua versions are stored differently.
4. Every terminal session can have a different environment configured. Default versions can also be configured.

![gif animation showing usage of luaver](http://i.imgur.com/dCCvNfR.gif)

## Requirements

Requires `make`, either of `wget` or `curl`.

You may need to install some dependencies:

```sh
sudo apt-get install libreadline-dev 
```

Also, if you are planning to install older versions of Lua(which are 32-bit) on 64-bit machines, you may need to install some 32-bit libraries: 

```sh
sudo apt-get install lib32ncurses5-dev
```

## Installation

### Install script

You can install from the script directly:

```sh
curl -fsSL https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh | sh -s - -r v1.0.0
```

Follow the instructions which appears after the luaver installation.

### Install using `git`

1. Clone this repository into `~/.luaver`:

    ```sh
    $ git clone https://github.com/DhavalKapil/luaver.git ~/.luaver
    ```

2. Add `. ~/.luaver/luaver` to your profile such as `.bashrc` or `.zshrc`:

    ```sh
    $ echo "[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver" >> ~/.bashrc
    $ echo "[ -s ~/.luaver/completions/luaver.bash ] && . ~/.luaver/completions/luaver.bash" >> ~/.bashrc
    ```

3. Reload `.bashrc` or restart the shell to load `luaver`:

   ```sh
   $ . ~/.bashrc
   ```

### Update using `git`

_Note: This method only works if luaver was installed using `git`._

```
$ cd ~/.luaver && git fetch origin && git reset --hard origin/master
```

Additional works may be required.

## Usage

### Sample usage:

```sh
luaver install 5.3.1             # Installs Lua version 5.3.1
luaver install 5.3.0             # Installs Lua version 5.3.0
luaver use 5.3.1                 # Switches to Lua version 5.3.1
luaver install-luarocks 2.3.0    # Installs Luarocks version 2.3.0
luaver uninstall 5.3.0           # Uninstalls Lua version 5.3.0
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
   luaver install-luajit <version>          Installs luajit-<version>
   luaver use-luajit <version>              Switches to luajit-<version>
   luaver set-default-luajit <version>      Sets <version> as default for luajit
   luaver unset-default-luajit              Unsets the default luajit version
   luaver uninstall-luajit <version>        Uninstalls luajit-<version>
   luaver list-luajit                       Lists installed luajit versions
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
