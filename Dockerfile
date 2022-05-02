# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang

## Add source code to the build stage.
ADD . /miniaudio
WORKDIR /miniaudio
ENV TRAVIS_COMPILER clang
ENV CC clang
ENV CC_FOR_BUILD clang

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN mkdir tgt && clang ./examples/engine_hello_world.c -o ./tgt/ehw -ldl -lm -lpthread

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

##
COPY --from=builder /miniaudio/tgt/ehw /