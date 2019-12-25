#! /bin/bash

set -x

echo 1 > /sys/module/kvm/parameters/ignore_msrs

sudo apt-add-repository main
sudo apt-get update

apt-get install qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools -y

git clone https://github.com/kholia/OSX-KVM.git /tmp/OSX-KVM

cd /tmp/OSX-KVM

sudo cp kvm.conf /etc/modprobe.d/kvm.conf

qemu-img create -f qcow2 mac_hdd_ng.img 128G

sudo ip tuntap add dev tap0 mode tap
sudo ip link set tap0 up promisc on
sudo ip link set dev virbr0 up
sudo ip link set dev tap0 master virbr0

#wget http://camplab.arges.feralhosting.com/BaseSystem.img /tmp/OSX-KVM/BaseSystem.img 

gsutil cp gs://baseimage/BaseSystem.img /tmp/OSX-KVM/BaseSystem.img

./boot-macOS-NG.sh
