# Quickstart

## Install LLVM

```bash
$ bash build-llvm.sh
```

All necessary tools including GCC, Clang and QEMU will be installed in `riscv/_install`.
You can add them to your `PATH` environment variable by executing `export PATH=$(pwd)/riscv/_install/bin:$PATH`.

## Build uCore

### 1. build lab1

```bash
$ cd labcodes_answer/lab1
$ make
$ make qemu # The kernel cannot run properly due to codegen errors in LLVM
```
