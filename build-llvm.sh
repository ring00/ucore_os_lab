sudo apt-get update
sudo apt-get -y install \
  binutils build-essential libtool texinfo \
  gzip zip unzip patchutils curl git \
  make cmake ninja-build automake bison flex gperf \
  grep sed gawk python bc \
  zlib1g-dev libexpat1-dev libmpc-dev \
  libglib2.0-dev libfdt-dev libpixman-1-dev 

mkdir riscv
cd riscv
mkdir _install
export PATH=`pwd`/_install/bin:$PATH

# gcc, binutils, newlib
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
pushd riscv-gnu-toolchain
./configure --prefix=`pwd`/../_install --enable-multilib
make -j`nproc`
popd

# qemu
git clone https://github.com/riscv/riscv-qemu
pushd riscv-qemu
./configure --prefix=`pwd`/../_install --target-list=riscv32-softmmu,riscv64-softmmu,riscv64-linux-user,riscv32-linux-user
make -j`nproc` install
popd

# LLVM
# git clone https://git.llvm.org/git/llvm.git
git clone https://mirrors.tuna.tsinghua.edu.cn/git/llvm/llvm.git
cd llvm/tools
# git clone https://git.llvm.org/git/clang.git
git clone https://mirrors.tuna.tsinghua.edu.cn/git/llvm/clang.git
cd ..
# [RISCV] Properly evaluate fixup_riscv_pcrel_lo12: https://reviews.llvm.org/D54029
# [WIP, RISCV] Generate address sequences suitable for mcmodel=medium: https://reviews.llvm.org/D54143
wget https://gist.githubusercontent.com/ring00/b3b35d7e5f0971ecd48ff566ea4cf12d/raw/814f91bd4e92d7f4c972bdbbf1e90c27fc9bc802/0001-Codegen-for-mcmodel-medium.patch
patch -p0 < 0001-Codegen-for-mcmodel-medium.patch
mkdir build && cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE="Release" \
  -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
  -DCMAKE_INSTALL_PREFIX="../../_install" \
  -DLLVM_OPTIMIZED_TABLEGEN=True -DLLVM_BUILD_TESTS=False \
  -DDEFAULT_SYSROOT="../../_install/riscv64-unknown-elf" \
  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf" \
  -DLLVM_TARGETS_TO_BUILD="" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV" ../
cmake --build . --target install
cd ../..

# Sanity test your new RISC-V LLVM
cat >hello.c <<END
#include <stdio.h>

int main(){
  printf("Hello RISCV!\n");
  return 0;
}
END

# 32 bit
clang -O -c hello.c --target=riscv32
riscv64-unknown-elf-gcc hello.o -o hello -march=rv32imac -mabi=ilp32
qemu-riscv32 hello

# 64 bit
clang -O -c hello.c
riscv64-unknown-elf-gcc hello.o -o hello -march=rv64imac -mabi=lp64
qemu-riscv64 hello
