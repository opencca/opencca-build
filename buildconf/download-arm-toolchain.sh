#!/usr/bin/env bash
set -euo pipefail
readonly __SCRIPT_DIR__=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function download_none_elf {
    local TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/11.3.rel1/binrel/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-elf.tar.xz?rev=73ff9780c12348b1b6772a1f54ab4bb3&hash=57C22236F869382FCF207B9A011E37D6438714EF"

    set +x

    mkdir -p $__SCRIPT_DIR__/build
    local BUILD_DIR=$__SCRIPT_DIR__/build
    local CURR_DIR=$(pwd)

    cd $BUILD_DIR

    local TOOLCHAIN_DIR=$BUILD_DIR/aarch64-none-elf
    local TOOLCHAIN_GZ=$BUILD_DIR/aarch64-none-elf.tar.xz
    local TOOLCHAIN_BIN=$TOOLCHAIN_DIR/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-elf

    if [ ! -f "$TOOLCHAIN_GZ" ]; then
        echo $TOOLCHAIN_URL
        wget $TOOLCHAIN_URL -O $TOOLCHAIN_GZ
        mkdir -p $TOOLCHAIN_DIR
        # tar --xz -xf $TOOLCHAIN_GZ -C $TOOLCHAIN_DIR
        xz --decompress -k $BUILD_DIR/aarch64-none-elf.tar.xz
        tar -xf $BUILD_DIR/aarch64-none-elf.tar.xz -C $TOOLCHAIN_DIR
    fi

    ln --relative -f -s $TOOLCHAIN_BIN $__SCRIPT_DIR__/aarch64-none-elf ||  true # ignore existing link

    set -x
    export PATH="$PATH:$__SCRIPT_DIR__/aarch64-none-elf/bin"
    set +x

    cd $CURR_DIR
}

function download_linux-gnu {

    local TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=6750d007ffbf4134b30ea58ea5bf5223&hash=0F1CE8273B8A30129CA04BD61FFB547D"

    set +x

    mkdir -p $__SCRIPT_DIR__/build
    local BUILD_DIR=$__SCRIPT_DIR__/build
    local CURR_DIR=$(pwd)
    cd $BUILD_DIR

    local TOOLCHAIN_DIR=$BUILD_DIR/aarch64-none-linux-gnu
    local TOOLCHAIN_GZ=$BUILD_DIR/aarch64-none-linux-gnu.tar.xz
    local TOOLCHAIN_BIN=$TOOLCHAIN_DIR/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu

    if [ ! -f "$TOOLCHAIN_GZ" ]; then
        echo $TOOLCHAIN_URL
        wget $TOOLCHAIN_URL -O $TOOLCHAIN_GZ
        mkdir -p $TOOLCHAIN_DIR

        xz --decompress -k $BUILD_DIR/aarch64-none-linux-gnu.tar.xz
        tar -xf $BUILD_DIR/aarch64-none-linux-gnu.tar -C $TOOLCHAIN_DIR
    fi

    ln --relative -f -s $TOOLCHAIN_BIN $__SCRIPT_DIR__/aarch64-none-linux-gnu ||  true # ignore existing link

    set -x
    export PATH="$PATH:$__SCRIPT_DIR__/aarch64-none-linux-gnu/bin"
    set +x
    
    cd $CURR_DIR

}


function download_14_2_none_elf {
    local TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf.tar.xz"

    set +x

    mkdir -p $__SCRIPT_DIR__/build
    local BUILD_DIR=$__SCRIPT_DIR__/build
    local CURR_DIR=$(pwd)
    local NAME=aarch64-none-elf

    cd $BUILD_DIR

    local TOOLCHAIN_DIR=$BUILD_DIR/$NAME
    local TOOLCHAIN_GZ=$BUILD_DIR/${NAME}.tar.xz
    local TOOLCHAIN_BIN=$TOOLCHAIN_DIR/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-elf

    if [ ! -f "$TOOLCHAIN_GZ" ]; then
        echo $TOOLCHAIN_URL
        wget $TOOLCHAIN_URL -O $TOOLCHAIN_GZ
        mkdir -p $TOOLCHAIN_DIR
        # tar --xz -xf $TOOLCHAIN_GZ -C $TOOLCHAIN_DIR
        xz --decompress -k $BUILD_DIR/${NAME}.tar.xz
        tar -xf $BUILD_DIR/${NAME}.tar.xz -C $TOOLCHAIN_DIR
    fi

    ln --relative -f -s $TOOLCHAIN_BIN $__SCRIPT_DIR__/$NAME ||  true # ignore existing link

    set -x
    export PATH="$PATH:$__SCRIPT_DIR__/$NAME/bin"
    set +x

    cd $CURR_DIR
}



set -x
ALL=none
COMMAND="${1:-$ALL}"

if [[  "$COMMAND" == "none" ]]; then
    download_14_2_none_elf
    # download_none_elf

elif [[  "$COMMAND" == "linux" ]]; then
    download_linux-gnu
    # download_none_elf
else
    download_14_2_none_elf
    download_linux-gnu
    # download_none_elf
fi


# export CROSS_COMPILE=$TOOLCHAIN_BIN/aarch64-none-elf-
# export CROSS_COMPILE=$TOOLCHAIN_BIN/aarch64-14_2_none-elf-
