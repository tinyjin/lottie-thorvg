# !/bin/bash

# Build for aarch64
sed -e "s/NDK/$1/g" -e "s/HOST_TAG/$2/g" ./cross/flutter_android_aarch64.txt > /tmp/.flutter_android_cross.txt

rm -rf build_flutter_aarch64 libthorvg.a
mkdir build_flutter_aarch64

cd ../thorvg
meson -Db_lto=true -Ddefault_library=static -Dloaders="lottie, png, jpg" --cross-file /tmp/.flutter_android_cross.txt ../lottie/build_flutter_aarch64

cd ../lottie
ninja -C build_flutter_aarch64

cp build_flutter_aarch64/src/libthorvg.a libthorvg.a
rm -rf build_flutter_aarch64/

meson -Db_lto=true -Ddefault_library=static --cross-file /tmp/.flutter_android_cross.txt build_flutter_aarch64
ninja -C build_flutter_aarch64/

# Build for x86_64
sed -e "s/NDK/$1/g" -e "s/HOST_TAG/$2/g" ./cross/flutter_android_x86_64.txt > /tmp/.flutter_android_cross.txt

rm -rf build_flutter_x86_64 libthorvg.a
mkdir build_flutter_x86_64

cd ../thorvg
meson -Db_lto=true -Ddefault_library=static -Dloaders="lottie, png, jpg" --cross-file /tmp/.flutter_android_cross.txt ../lottie/build_flutter_x86_64

cd ../lottie
ninja -C build_flutter_x86_64

cp build_flutter_x86_64/src/libthorvg.a libthorvg.a
rm -rf build_flutter_x86_64/

meson -Db_lto=true -Ddefault_library=static --cross-file /tmp/.flutter_android_cross.txt build_flutter_x86_64
ninja -C build_flutter_x86_64/

rm -rf libthorvg.a

cp build_flutter_aarch64/libthorvg.a ../android/src/main/jniLibs/arm74-v8a
cp build_flutter_aarch64/libthorvg.a ../android/src/main/jniLibs/armeabi-v7a
cp build_flutter_x86_64/libthorvg.a ../android/src/main/jniLibs/x86_64
