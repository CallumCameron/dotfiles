# -*- Shell-script -*-
#
# Environment variables go here, so they are visible to GUI programs
# as well as the shell. This file might not be executed by bash (at
# least on Ubuntu/Mint it is executed by dash), so it better be POSIX
# correct (same goes for ~/.dotfiles-variables.sh).
#

test ! -z "${DOTFILES_PROFILING}" && printf 'env ' && date --rfc-3339=ns

umask 077

export DOTFILES_OS=''
export DOTFILES_LINUX_VARIANT=''

if [ -d '/system' ]; then
    export DOTFILES_OS='android'
elif [ "$(uname -o)" = 'Cygwin' ]; then
    export DOTFILES_OS='cygwin'
else
    export DOTFILES_OS='linux'
    if [ -d '/android' ]; then
        export DOTFILES_LINUX_VARIANT='android'
    elif [ -e '/boot/config.txt' ]; then
        export DOTFILES_LINUX_VARIANT='pi'
    elif which lsb_release >/dev/null && lsb_release -a 2>/dev/null | grep 'Mint' >/dev/null; then
        export DOTFILES_LINUX_VARIANT='main'
    fi
fi

export DOTFILES_CORE_DIR="${DOTFILES_DIR}/core"

export DOTFILES_VARIABLES="${DOTFILES_CORE_DIR}/environment-variables.sh"
export DOTFILES_GENERIC_ALIASES="${DOTFILES_CORE_DIR}/generic-aliases.bash"
export DOTFILES_BASH_ALIASES="${DOTFILES_CORE_DIR}/bash-aliases.bash"
export DOTFILES_ZSH_ALIASES="${DOTFILES_CORE_DIR}/zsh-aliases.zsh"
export DOTFILES_LOGOUT_SCRIPT="${DOTFILES_CORE_DIR}/logout.sh"
export DOTFILES_EMACS_INIT="${DOTFILES_CORE_DIR}/dotfiles.el"
export DOTFILES_DEFAULT_DOTFILES="${DOTFILES_CORE_DIR}/default-dotfiles"
export DOTFILES_BASH_COMMON="${DOTFILES_CORE_DIR}/common.bash"
export DOTFILES_CORE_BIN="${DOTFILES_CORE_DIR}/bin"

export DOTFILES_LOCAL_VARIABLES="${HOME}/.dotfiles-variables.sh"
export DOTFILES_LOCAL_ALIASES="${HOME}/.dotfiles-aliases"
export DOTFILES_LOCAL_EMACS="${HOME}/.dotfiles-emacs.el"
export DOTFILES_LOCAL_BIN="${HOME}/.bin"

export DOTFILES_NEXT_LOGIN="${HOME}/.dotfiles-next-login.bash"
export DOTFILES_NEXT_INIT="${HOME}/.dotfiles-next-init.bash"
export DOTFILES_NEEDS_LOGOUT="${HOME}/.dotfiles-needs-logout"

if [ -e "${DOTFILES_NEEDS_LOGOUT}" ]; then
    rm -f "${DOTFILES_NEEDS_LOGOUT}"
fi

export DOTFILES_PACKAGE_SCRIPTS="${DOTFILES_CORE_DIR}/package-scripts"
export DOTFILES_PACKAGE_INSTALL_DIR="${HOME}/.dotfiles-packages"
export DOTFILES_PACKAGE_CONF_DIR="${DOTFILES_DIR}/packages"
export DOTFILES_PACKAGE_MUTEX="${HOME}/.dotfiles-package-mutex"
export DOTFILES_PACKAGE_MESSAGES_FILE="${HOME}/.dotfiles-package-messages"
export DOTFILES_PACKAGE_PROBLEMS_FILE="${HOME}/.dotfiles-package-problems"

export DOTFILES_PRIVATE_DIR="${DOTFILES_DIR}/private"
export DOTFILES_PRIVATE_PACKAGE_CONF_DIR="${DOTFILES_PRIVATE_DIR}/packages"
export DOTFILES_PRIVATE_REPO=''

if [ -e "${DOTFILES_PACKAGE_MESSAGES_FILE}" ]; then
    rm -f "${DOTFILES_PACKAGE_MESSAGES_FILE}"
fi

if [ -e "${DOTFILES_PACKAGE_PROBLEMS_FILE}" ]; then
    rm -f "${DOTFILES_PACKAGE_PROBLEMS_FILE}"
fi

export DOTFILES_CAN_SUDO_FILE="${HOME}/.dotfiles-can-sudo"
if [ -e "${DOTFILES_CAN_SUDO_FILE}" ]; then
    # shellcheck disable=SC2155
    export DOTFILES_CAN_SUDO="$(cat "${DOTFILES_CAN_SUDO_FILE}")"
else
    export DOTFILES_CAN_SUDO=''
fi

export DOTFILES_ETC_DIR='/etc/dotfiles'

export PATH="${DOTFILES_CORE_BIN}:${PATH}"

export EDITOR='nano'
export PAGER='less'
export LESS='FRMX'


# Create SSH agent if necessary
if [ -z "${SSH_AUTH_SOCK}" ] && [ -z "${DISPLAY}" ] && which ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)" >/dev/null 2>/dev/null
    export DOTFILES_STARTED_SSH_AGENT='t'
    # shellcheck disable=SC2155
    export DOTFILES_SSH_ADDED_FILE="$(readlink -f "$(mktemp)")"
elif [ "${DOTFILES_OS}" = 'linux' ] && [ "${DOTFILES_LINUX_VARIANT}" = 'android' ]; then
    # Already running an ssh agent, but for some reason ssh won't connect to it by itself
    export DOTFILES_STARTED_SSH_AGENT='t'
    # shellcheck disable=SC2155
    export DOTFILES_SSH_ADDED_FILE="$(readlink -f "$(mktemp)")"
fi


# Use the ~/.dotfiles-variables.sh file for stuff that should be
# visible to GUI programs, but should not be version controlled.
if [ -f "${DOTFILES_LOCAL_VARIABLES}" ]; then
    . "${DOTFILES_LOCAL_VARIABLES}"
fi


# Load packages
. "${DOTFILES_PACKAGE_SCRIPTS}/load-packages-env.sh"
loadpackagesenv "${DOTFILES_PACKAGE_CONF_DIR}"
test -d "${DOTFILES_PRIVATE_PACKAGE_CONF_DIR}" && loadpackagesenv "${DOTFILES_PRIVATE_PACKAGE_CONF_DIR}"
loadpackagesenvcleanup


export PATH="${DOTFILES_LOCAL_BIN}:${PATH}"


if [ -f "${DOTFILES_NEXT_LOGIN}" ]; then
    bash "${DOTFILES_NEXT_LOGIN}"
    rm "${DOTFILES_NEXT_LOGIN}"
fi

test ! -z "${DOTFILES_PROFILING}" && printf 'env ' && date --rfc-3339=ns
