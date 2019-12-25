#! /bin/bash

set -x

echo 1 > /sys/module/kvm/parameters/ignore_msrs

apt-get git install qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools -y

git clone https://github.com/kholia/OSX-KVM.git /tmp/OSX-KVM

sudo cp /tmp/OSX-KVM/kvm.conf /etc/modprobe.d/kvm.conf
