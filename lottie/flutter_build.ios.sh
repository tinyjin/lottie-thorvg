#!/bin/bash

rm -rf build_flutter_ios

# Build for aarch64
rm -rf build_flutter_aarch64 libthorvg.a
mkdir build_flutter_aarch64

cd ../thorvg
meson -Db_lto=true -Ddefault_library=static -Dloaders="lottie, png, jpg" --cross-file ../lottie/cross/flutter_ios_aarch64.txt ../lottie/build_flutter_aarch64

cd ../lottie
ninja -C build_flutter_aarch64

cp build_flutter_aarch64/src/libthorvg.a libthorvg.a
rm -rf build_flutter_aarch64/

meson -Db_lto=true -Ddefault_library=static --cross-file ./cross/flutter_ios_aarch64.txt build_flutter_aarch64
ninja -C build_flutter_aarch64/

# Build for x86_64
rm -rf build_flutter_x86_64 libthorvg.a
mkdir build_flutter_x86_64

cd ../thorvg
meson -Db_lto=true -Ddefault_library=static -Dloaders="lottie, png, jpg" --cross-file ../lottie/cross/flutter_ios_x86_64.txt ../lottie/build_flutter_x86_64

cd ../lottie
ninja -C build_flutter_x86_64

cp build_flutter_x86_64/src/libthorvg.a libthorvg.a
rm -rf build_flutter_x86_64/

meson -Db_lto=true -Ddefault_library=static --cross-file ./cross/flutter_ios_x86_64.txt build_flutter_x86_64
ninja -C build_flutter_x86_64/

rm -rf libthorvg.a

mkdir build_flutter_ios

# Legacy fat binary (aarch64 simulator not supported)
lipo build_flutter_x86_64/libthorvg.dylib \
build_flutter_aarch64/libthorvg.dylib \
-output build_flutter_ios/libthorvg.dylib -create

cp build_flutter_ios/libthorvg.dylib ../ios/Frameworks/

