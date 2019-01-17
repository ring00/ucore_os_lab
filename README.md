# Quickstart

## Install LLVM

```bash
$ bash setup.sh
```

All necessary tools including GCC, Clang and QEMU will be installed in `riscv/_install`.
You can add them to your `PATH` environment variable by executing `export PATH=$(pwd)/riscv/_install/bin:$PATH`.

## Build uCore

```bash
$ cd src
$ ./clangbuildall.sh
```

## Run uCore

```bash
$ cd lab8
$ make qemu
```
## Demo

[![asciicast](https://asciinema.org/a/yJ5c8TA1I7q2qOfHIg7C11qIL.svg)](https://asciinema.org/a/yJ5c8TA1I7q2qOfHIg7C11qIL)
