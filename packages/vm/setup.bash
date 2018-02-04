function _can-install() {
    os linux &&
    linux-variant main &&
    can-sudo
}

function _install() {
    # Virtualbox
    echo deb https://download.virtualbox.org/virtualbox/debian xenial contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list &&
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add - &&
    sudo apt-get update &&
    sudo apt-get -y install virtualbox-5.2 &&
    sudo adduser "$(id -un)" vboxusers &&

    # Vagrant
    wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb &&
    sudo gdebi vagrant_2.0.2_x86_64.deb &&
    rm vagrant_2.0.2_x86_64.deb
}
