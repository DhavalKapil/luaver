#!/bin/sh

oneTimeSetUp() {
    # shellcheck disable=SC1091
    . ./test_helper
    setup_luaver
    install_lua 5.3.1

    # shellcheck disable=SC1091
    . ../../luaver_rockset
}

testCleanedPath()
{
    myPATH="$LUAVER_DIR/rockset/b/share/bin:$LUAVER_DIR/rockset/b/bin:/bin"
    assertEquals "$LUAVER_DIR/rockset/b/share/bin:/bin" "$(__luaver_rockset__cleaned_path "$myPATH")"
}

testCurrentPrefixInvalid()
{
    __luaver_rockset__current_prefix ":"
    assertFalse 'It should fail with an invalid PATH' "$?"
}

testCurrentPrefixValid()
{
    myPATH="$LUAVER_DIR/rockset/b/share/bin:$LUAVER_DIR/rockset/b/bin:$PATH"
    assertEquals "$LUAVER_DIR/rockset/b" "$(__luaver_rockset__current_prefix "$myPATH")"
}

testDownloadInvalid()
{
    __luaver_rockset__download "/luarocks-2.4.1.tar.gz"
    assertFalse 'It should fail with an invalid URL' "$?"
}

testDownloadValid()
{
    __luaver_rockset__download "https://luarocks.org/releases/luarocks-2.4.1.tar.gz"
    assertTrue 'It should succeed with a valid URL' "$?"

    [ -f "$LUAVER_DIR/src/luarocks-2.4.1.tar.gz" ]
    assertTrue 'The downloaded archive should exists' "$?"
}

testExtractInvalid()
{
    __luaver_rockset__extract "invalid.tar.gz"
    assertFalse 'It should fail with an invalid archive' "$?"
}

testExtractValid()
{
    __luaver_rockset__download "https://luarocks.org/releases/luarocks-2.4.1.tar.gz"
    __luaver_rockset__extract "luarocks-2.4.1.tar.gz"
    assertTrue 'It should succeed with a valid archive' "$?"

    [ -d "$LUAVER_DIR/src/luarocks-2.4.1" ]
    assertTrue 'The extracted directory should exists' "$?"
}

testCompileInvalid()
{
    __luaver_rockset__luarocks_compile "invalid" "$LUAVER_DIR/rockset/a"
    assertFalse 'It should fail with an invalid source' "$?"
}

testCompileValid()
{
    __luaver_rockset__download "http://luarocks.org/releases/luarocks-2.4.1.tar.gz"
    __luaver_rockset__extract "luarocks-2.4.1.tar.gz"
    __luaver_rockset__luarocks_compile "luarocks-2.4.1" "$LUAVER_DIR/rockset/a"
    assertTrue 'It should succeed with a valid URL' "$?"
}

testLuaVersion()
(
    assertEquals 5.3.1 "$(__luaver_rockset__lua_version)"
)

testCreate()
{
    luaver_rockset create a 2.4.1
    assertTrue 'It should succeed with a valid version' "$?"
}

testUse()
(
    prefix="$LUAVER_DIR/rockset/a_$(__luaver_rockset__lua_version)"

    command mkdir -p "$prefix/bin"
    'echo' "echo export LUA_PATH=1 LUA_CPATH=1" >"$prefix/bin/luarocks"
    command chmod a+x "$prefix/bin/luarocks"

    luaver_rockset use a
    assertTrue 'It should succeed with a valid Luarocks executable' "$?"    
)

testDelete()  
{
    command mkdir -p "$LUAVER_DIR/rockset/a_$(__luaver_rockset__lua_version)/bin"
    luaver_rockset delete a
    assertTrue 'It should succeed with a valid rockset' "$?"
}

testCurrent()  
(
    # shellcheck disable=SC2030,SC2031
    PATH="$LUAVER_DIR/rockset/r/bin:$PATH"
    assertEquals r "$(luaver_rockset current)"
)

testList()  
(
    # shellcheck disable=SC2030,SC2031
    PATH="$LUAVER_DIR/rockset/a_$(__luaver_rockset__lua_version)/bin:$PATH"
    command rm -r "$LUAVER_DIR/rockset/"*
    command mkdir -p "$LUAVER_DIR/rockset/a_$(__luaver_rockset__lua_version)/bin"
    assertEquals "a_$(__luaver_rockset__lua_version)" "$(luaver_rockset list)"
)

# shellcheck disable=SC2034
SHUNIT_PARENT=$0

# shellcheck disable=SC1091
. ./shunit2