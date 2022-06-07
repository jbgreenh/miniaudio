# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang opus-tools libogg0 libopus0 libopusfile-dev libvorbis-dev libopus-dev

## Add source code to the build stage.
ADD . /miniaudio
WORKDIR /miniaudio
ENV TRAVIS_COMPILER clang
ENV CC clang
ENV CC_FOR_BUILD clang

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN clang ./examples/fuzz_custom_decoder.c -o ./ehw -fsanitize=fuzzer -ldl -lm -lpthread 
#RUN clang ./examples/engine_hello_world.c -o ./ehw -ldl -lm -lpthread 

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

##
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libogg0 libopus0 libopusfile-dev libvorbis-dev libopus-dev
COPY --from=builder /miniaudio/ehw /