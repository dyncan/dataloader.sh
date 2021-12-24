#!/bin/bash

# DIR="$( cd "$( dirname "$0" )" && pwd )"

chmod +x *.sh

source ./load_env.sh

load_env

sh ./bin/exports/Account.sh $VERSION


