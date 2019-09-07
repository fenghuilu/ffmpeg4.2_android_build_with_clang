#!/bin/bash
# 清空上次的编译
make clean
#你自己的NDK路径.
export NDK=/home/feng/Android/Sdk/ndk/20.0.5594570

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

SYSROOT=$TOOLCHAIN/sysroot

#目标android版本
ANDROID_API=29
export CFLAGS="-D__ANDROID_API__=$ANDROID_API"
export CXXFLAGS="-D__ANDROID_API__=$ANDROID_API"

function build_android
{
echo "Compiling FFmpeg for $CPU"
./configure \
    --disable-x86asm \
    --prefix=$PREFIX \
    --enable-neon \
    --enable-hwaccels \
    --enable-gpl \
    --enable-postproc \
    --disable-shared \
    --enable-static \
    --enable-jni \
    --enable-mediacodec \
    --enable-decoder=h264_mediacodec \
    --disable-doc \
    --enable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --enable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --cc=${ANDROID_CROSS_PREFIX}-clang \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make -j8
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
ANDROID_CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android$ANDROID_API
PREFIX=$(pwd)/android/$CPU
build_android

#armv7-a
ARCH=arm
CPU=armv7-a
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
ANDROID_CROSS_PREFIX=$TOOLCHAIN/bin/armv7a-linux-androideabi$ANDROID_API
PREFIX=$(pwd)/android/$CPU
build_android

#x86
ARCH=x86
CPU=x86
CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
ANDROID_CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android$ANDROID_API
PREFIX=$(pwd)/android/$CPU
build_android

#x86_64
ARCH=x86_64
CPU=x86-64
CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
ANDROID_CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android$ANDROID_API
PREFIX=$(pwd)/android/$CPU
build_android

