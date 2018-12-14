# Quickstart

## Install LLVM

```bash
$ bash build-llvm.sh
```

All necessary tools including GCC, Clang and QEMU will be installed in `riscv/_install`.
You can add them to your `PATH` environment variable by executing `export PATH=$(pwd)/riscv/_install/bin:$PATH`.

## Build uCore

```bash
$ cd labcodes_answer
$ ./clangbuildall.sh
```
## Run uCore

```bash
$ cd lab8
$ make qemu
```
