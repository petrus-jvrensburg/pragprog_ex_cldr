#!/usr/bin/env bash
cd ~/Book

# the rake bash script will check for this variable and
# will only run the actual build if this is set.
export PP_DOCKER_CONTEXT=true
export JAVA_HOME=/usr
export LANG=C.UTF-8


# change the path to the bookinfo to look in the current dir.
# The rake file will have moved it there.

cp book.pml book.dockertemp
sed -e 's|file="../bookinfo|file="bookinfo|' book.dockertemp > book.pml

echo "Using Docker to run the build"
# pass args to rake bash script.
./rake "$@"

# put the old book.pml file back.
mv book.dockertemp book.pml
