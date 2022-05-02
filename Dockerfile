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
RUN clang ./examples/fuzz_engine.c -o ./ehw -fsanitize=fuzzer -ldl -lm -lpthread 

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

##
COPY --from=builder /miniaudio/ehw /