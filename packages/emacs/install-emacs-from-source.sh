#!/bin/bash

function usage() {
    echo "Usage: $(basename "${0}") install_dir"
    exit 1
}

test -z "${1}" && usage
INSTALL_DIR="$(readlink -f "${1}")"

sudo apt-get -y install attr autoconf automake build-essential imagemagick libacl1-dev libasound2-dev libdbus-1-dev libgconf2-dev libgif-dev libgnutls-dev libgpm-dev libgtk-3-dev liblockfile-dev libm17n-dev libmagickwand-dev libncurses5-dev libotf-dev libpng-dev libpoppler-glib-dev librsvg2-dev libselinux1-dev libxpm-dev libz-dev paxctl texinfo valgrind

function do-make() {
    # Take account of particular requirements on Android Linux
    local TWEAK='/proc/sys/kernel/randomize_va_space'
    local ORIGINAL
    if [ "${DOTFILES_OS}" = 'linux' ] && [ "${DOTFILES_LINUX_VARIANT}" = 'android' ]; then
        ORIGINAL="$(cat "${TWEAK}")"
        echo 0 | sudo tee "${TWEAK}" &>/dev/null
    fi

    local RETVAL
    make
    RETVAL=$?

    if [ "${DOTFILES_OS}" = 'linux' ] && [ "${DOTFILES_LINUX_VARIANT}" = 'android' ]; then
        echo "${ORIGINAL}" | sudo tee "${TWEAK}" &>/dev/null
    fi

    return ${RETVAL}
}

if [ ! -e "${INSTALL_DIR}/bin/emacs" ]; then
    BUILD_DIR="$(mktemp -d)" &&
    cd "${BUILD_DIR}" &&
    wget 'http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz' &&
    tar -xf 'emacs-24.5.tar.xz' &&
    cd 'emacs-24.5' &&
    ./configure "--prefix=${INSTALL_DIR}" &&
    do-make &&
    make install &&
    cd &&
    rm -rf "${BUILD_DIR}" || exit 1
fi
exit 0
