function _can-install() {
    os linux && known-linux-variant && can-sudo
}

function _install() {
    local TARGET='/etc/sudoers.d/umask'
    sudo cp "${PACKAGE_CONF_DIR}/umask" "${TARGET}" &&
    sudo chown root:root "${TARGET}" &&
    sudo chmod ug=r "${TARGET}" &&
    sudo chmod o-rwx "${TARGET}"
}

function _update() {
    _install
}
