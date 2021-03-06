#!/bin/sh

# Use this script only against a fresh ubuntu server
#    curl -sS -H "Cache-Control: no-cache" https://raw.githubusercontent.com/BenjaminAbt/Ubuntu-Kubernetes/master/ubuntu-install-kubernetes.sh | sudo bash

# disable swap
swapoff -a
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab # disable swap after reboot

# update package index and install https apt
apt-get update && apt-get install -y apt-transport-https

# add docker gpg key
curl -sS -H "Cache-Control: no-cache" https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add docker to package repositories
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# update package index and install docker
apt update && apt install -qy docker-ce

# add google pgp key
curl -sS -H "Cache-Control: no-cache" https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# update index and install k8s tools
apt-get update && apt-get install -y kubeadm kubelet kubectl

# kubeadm config
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

# install helm
curl -sS -H "Cache-Control: no-cache" https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash
