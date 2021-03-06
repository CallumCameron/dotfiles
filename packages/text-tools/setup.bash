function _can-install() {
    os linux && linux-variant main pi && can-sudo
}

function _install() {
    sudo apt-get -y install asciidoc aspell biber catdoc chktex dict dictd dict-foldoc dict-gcide dict-jargon dict-wn epstool hunspell hunspell-en-gb markdown strip-nondeterminism texinfo texlive-full transfig unoconv || exit 1

    if [ ! -d "${PACKAGE_INSTALL_DIR}" ]; then
        mkdir -p "${PACKAGE_INSTALL_DIR}" &&
        cd "${PACKAGE_INSTALL_DIR}" &&
        git clone https://github.com/prosegrinder/pandoc-templates &&
        git clone https://github.com/calliecameron/markdown-makefile || exit 1
    fi

    if linux-variant main; then
        if ! which pandoc &>/dev/null; then
            TMPDIR="$(mktemp -d)" &&
            wget -O "${TMPDIR}/pandoc.deb" https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-1-amd64.deb &&
            sudo dpkg -i "${TMPDIR}/pandoc.deb" &&
            rm "${TMPDIR}/pandoc.deb" &&
            rmdir "${TMPDIR}" || exit 1
        fi
    fi
}

function _update() {
    _install &&
    cd "${PACKAGE_INSTALL_DIR}/pandoc-templates" &&
    git pull &&
    cd "${PACKAGE_INSTALL_DIR}/markdown-makefile" &&
    git pull
}
