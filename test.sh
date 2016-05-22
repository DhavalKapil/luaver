source ~/.bashrc

# Installing lua 5.3.2
echo "Y" | luavm install 5.3.2

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.2}" == "${version_string}"
then
    exit 1
fi

# Installing lua 5.3.1
echo "Y" | luavm install 5.3.1

# Confirming
version_string=$(lua -v)
if test "${version_string#*5.3.1}" == "${version_string}"
then
    exit 1
fi

# Installing luarocks 2.3.0
echo "Y" | luavm install-luarocks 2.3.0

# Confirming
version_string=$(luarocks)
if test "${version_string#*2.3.0}" == "${version_string}"
then
    exit 1
fi
