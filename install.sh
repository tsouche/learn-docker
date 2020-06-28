#! /bin/bash

# We assume that the user who will run this script has sudo privilege

# isntall git, curl and virtualbox
sudo apt-get update
sudo apt-get install git curl
sudo apt install virtualbox virtualbox-ext-pack

# install docker, and addd the user to the docker group
snap install docker
sudo usermod -aG docker ${USER}

# install docker-compose and docket-machine
target=/usr/local/bin
base=https://github.com/docker/compose/releases/download/1.26.0/
sudo curl -L $base/docker-compose-$(uname -s)-$(uname -m) -o $target/docker-compose
sudo chmod +x $target/docker-compose

base=https://github.com/docker/machine/releases/download/v0.16.0
sudo curl -L $base/docker-machine-$(uname -s)-$(uname -m) -o $target/docker-machine
sudo chmod +x $target/docker-machine
