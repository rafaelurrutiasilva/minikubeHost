#!/bin/bash
#

if [[ ! $(uname -a) =~ "photon" ]];then
    echo "You are not running Photon OS as Linux OS!"
    echo "You need to replace 'tdnf' package manager whit the one used in your Linux OS."
    exit
fi

# Start ENVs
myHOSTNAME=minikubeHost

# Install beasic tool
echo "Installing beasic tool and setting the hostname"
hostnamectl hostname $myHOSTNAME
tdnf install sudo tar  -y
tdnf update -y

# Post installation and configuration for Docker
echo "Post installation and configuration for Docker"
systemctl enable docker
systemctl start docker
useradd  -m labuser
usermod -aG docker labuser

# Minikube install
echo "Installing latest minikube stable releas"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install -m 755 minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Installing latest kubectl stable releas.
echo "Installing latest kubectl stable releas"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Reboot needed to sett the hostname
echo "The host will now bee rebooted..."
sleep 5
reboot
