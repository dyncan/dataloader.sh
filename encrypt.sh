#/bin/sh

chmod +x *.sh

source ./load_env.sh

load_env

ant encrypt -Dpassword=$PASSWORD -Dapiversion=$VERSION