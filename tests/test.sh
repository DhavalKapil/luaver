. ~/.luavm/luavm

echo "Y" > yes

# Installing lua 5.3.2
luavm install 5.3.2 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" == "${version_string}"
then
    exit 1
fi

# Installing lua 5.3.1
luavm install 5.3.1 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.1}" == "${version_string}"
then
    exit 1
fi

# Installing luarocks 2.3.0
luavm install-luarocks 2.3.0 < yes

# Confirming
version_string=$(luarocks)
if test "${version_string#*2.3.0}" == "${version_string}"
then
    exit 1
fi

luarocks install --server=http://luarocks.org/dev elasticsearch

lua luarocks_test.lua

if [ $? == 1 ]
then
	exit 1
fi
