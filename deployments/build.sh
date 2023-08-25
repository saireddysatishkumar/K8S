#!/bin/bash

set -x

# setup default values, use environment variables to override
# for example: export LESSON=171 VER=v1 && ./build.sh
VER="${VER:-latest}"
LESSON="${LESSON:-0}"

# myapp
docker build -t saireddysatishkumar/myapp-${LESSON}-arm64:${VER} -f myapp/Dockerfile --platform linux/arm64 myapp
docker build -t saireddysatishkumar/myapp-${LESSON}-amd64:${VER} -f myapp/Dockerfile --platform linux/amd64 myapp

docker push saireddysatishkumar/myapp-${LESSON}-arm64:${VER}
docker push saireddysatishkumar/myapp-${LESSON}-amd64:${VER}

docker manifest create saireddysatishkumar/myapp-${LESSON}:${VER} \
    saireddysatishkumar/myapp-${LESSON}-arm64:${VER} \
    saireddysatishkumar/myapp-${LESSON}-amd64:${VER}

docker manifest push saireddysatishkumar/myapp-${LESSON}:${VER}
