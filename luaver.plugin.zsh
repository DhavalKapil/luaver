SOURCE=${(%):-%N}
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
PLUGIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $PLUGIN_DIR/luaver
fpath=($PLUGIN_DIR/completions $fpath)

