/*
This example demonstrates how to initialize an audio engine and play a sound.

This will play the sound specified on the command line.
*/
#define MINIAUDIO_IMPLEMENTATION
#include "../miniaudio.h"

#include <stdio.h>

char *buf_to_file(const uint8_t *buf, size_t size) {
  char *pathname = strdup("/tmp/fuzz-XXXXXX");
  if (pathname == NULL) {
    return NULL;
  }

  int fd = mkstemp(pathname);
  if (fd == -1) {
    free(pathname);
    return NULL;
  }

  size_t pos = 0;
  while (pos < size) {
    int nbytes = write(fd, &buf[pos], size - pos);
    if (nbytes <= 0) {
      if (nbytes == -1 && errno == EINTR) {
        continue;
      }
      goto err;
    }
    pos += nbytes;
  }

  if (close(fd) == -1) {
    goto err;
  }

  return pathname;

err:
  return NULL;
}

int LLVMFuzzerTestOneInput(char* data, size_t size)
{
    ma_result result;
    ma_engine engine;

    result = ma_engine_init(NULL, &engine);
    if (result != MA_SUCCESS) {
        printf("Failed to initialize audio engine.");
        return -1;
    }

    buf_to_file(data, size);

    ma_engine_play_sound(&engine, "/tmp/fuzz-XXXXXX", NULL);

    ma_engine_uninit(&engine);

    return 0;
}
