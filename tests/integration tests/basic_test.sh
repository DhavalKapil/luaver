. ~/.luaver/luaver

echo "Y" > yes
echo "Y" > yes_yes_yes
echo "Y" >> yes_yes_yes
echo "Y" >> yes_yes_yes

# Installing lua 5.3.2
luaver install 5.3.2 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" = "${version_string}"
then
    exit 1
fi

# Installing lua 5.3.1
luaver install 5.3.1 < yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.1}" = "${version_string}"
then
    exit 1
fi

# Installing luarocks 2.3.0
luaver install-luarocks 2.3.0 < yes

# Confirming
version_string=$(luarocks)
if test "${version_string#*2.3.0}" = "${version_string}"
then
    exit 1
fi

# Confirming that lua is still 5.3.1
version_string=$(lua -v)
if test "${version_string#*5.3.1}" = "${version_string}"
then
    exit 1
fi

luarocks install elasticsearch

lua ./tests/integration\ tests/luarocks_test.lua

if [ $? = 1 ]
then
	exit 1
fi

luaver uninstall 5.3.1

lua

if [ $? = 0 ]
then
    exit 1
fi

luaver use 5.3.2

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" = "${version_string}"
then
    exit 1
fi

luaver install 5.2.4 < yes_yes_yes

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.2.4}" = "${version_string}"
then
    exit 1
fi

luarocks install elasticsearch

lua ./tests/integration\ tests/luarocks_test.lua

if [ $? = 1 ]
then
	exit 1
fi

luaver set-default 5.2.4
luaver set-default-luarocks 2.3.0
