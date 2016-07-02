. ~/.luaver/luaver

echo "Y" > yes

# Installing lua 5.3.2
luaver install 5.3.2 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" == "${version_string}"
then
    exit 1
fi

# Installing lua 5.3.1
luaver install 5.3.1 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.1}" == "${version_string}"
then
    exit 1
fi

# Installing luarocks 2.3.0
luaver install-luarocks 2.3.0 < yes

# Confirming
version_string=$(luarocks)
if test "${version_string#*2.3.0}" == "${version_string}"
then
    exit 1
fi

luarocks install --server=http://luarocks.org/dev elasticsearch

lua ./tests/integration/luarocks_test.lua

if [ $? == 1 ]
then
	exit 1
fi

luaver uninstall 5.3.1

lua

if [ $? == 0 ]
then
    exit 1
fi

luaver use 5.3.2

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" == "${version_string}"
then
    exit 1
fi
