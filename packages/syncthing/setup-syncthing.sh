#!/bin/bash

source "${DOTFILES_BASH_COMMON}" &&

curl -s https://syncthing.net/release-key.txt | sudo apt-key add - &&
echo 'deb https://apt.syncthing.net/ syncthing stable' | sudo tee /etc/apt/sources.list.d/syncthing-release.list &&

curl -s https://download.opensuse.org/repositories/home:/kozec/xUbuntu_18.04/Release.key | sudo apt-key add - &&
echo 'deb https://download.opensuse.org/repositories/home:/kozec/xUbuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/syncthing-gtk.list &&

sudo apt-get update &&

sudo apt-get -y install syncthing syncthing-gtk || exit 1

if yn-n "Open firewall port for Syncthing (TCP 22000 and UDP 21027)?"; then
    port open-at-boot 22000 tcp &&
    port open-at-boot 21027 udp &&
    port open 22000 tcp &&
    port open 21027 udp || exit 1
else
    port dont-open-at-boot 22000 tcp &&
    port dont-open-at-boot 21027 udp || exit 1
fi

exit 0
