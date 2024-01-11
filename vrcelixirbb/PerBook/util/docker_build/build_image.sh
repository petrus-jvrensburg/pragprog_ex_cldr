#!/usr/bin/env bash

docker stop ppbookshelf/buildbox
docker rm ppbookshelf/buildbox

docker rmi pragprog/buildbox
# copy dockerfile and ignore file to the folder containing Book, Common, PerBook
cp Dockerfile ../../../Dockerfile
cp .dockerignore ../../../.dockerignore

# move to the folder containing Book, Common, PerBook
pushd ../../../

# DOCKER_BUILDKIT=1 is for the new version of the build engine which gives
# faster build times. Does not work on Windows. Build this container on mac or linux
DOCKER_BUILDKIT=1 docker build . -t ppbookshelf/bookbuilder

# remove the copies
rm Dockerfile
rm .dockerignore
popd

docker tag ppbookshelf/bookbuilder ppbookshelf/bookbuilder:$(cat ./version.txt)

