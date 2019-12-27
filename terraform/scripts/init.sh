#! /bin/bash

set -x

echo 1 > /sys/module/kvm/parameters/ignore_msrs

sudo apt-add-repository main
sudo apt-get update

apt-get install qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools -y

git clone https://github.com/kholia/OSX-KVM.git /tmp/OSX-KVM

sed -i 's/-m 3072/-m 16384/g' /tmp/OSX-KVM/boot-macOS-NG.sh
sed -i 's/cores=2/cores=4/g' /tmp/OSX-KVM/boot-macOS-NG.sh
sed -i 's/-vga vmware/-vnc :0/g' /tmp/OSX-KVM/boot-macOS-NG.sh

cd /tmp/OSX-KVM

sudo cp kvm.conf /etc/modprobe.d/kvm.conf

qemu-img create -f qcow2 mac_hdd_ng.img 128G

sudo ip tuntap add dev tap0 mode tap
sudo ip link set tap0 up promisc on
sudo ip link set dev virbr0 up
sudo ip link set dev tap0 master virbr0

#wget http://camplab.arges.feralhosting.com/BaseSystem.img /tmp/OSX-KVM/BaseSystem.img 

if $(gsutil ls gs://baseimage/ | grep -q mac_hdd_ng.img);
then 
  gsutil cp gs://baseimage/mac_hdd_ng.img .

  cat <<EOF >/tmp/OSX-KVM/boot-macOS-NG.sh
#!/bin/bash

# qemu-img create -f qcow2 mac_hdd_ng.img 128G
#
# echo 1 > /sys/module/kvm/parameters/ignore_msrs (this is required)

############################################################################
# NOTE: Tweak the "MY_OPTIONS" line in case you are having booting problems!
############################################################################

# This works for High Sierra as well as Mojave. Tested with macOS 10.13.6 and macOS 10.14.4.

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

# OVMF=./firmware
OVMF="./"

qemu-system-x86_64 -enable-kvm -m 3072 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine q35 \
	  -smp 4,cores=2 \
	  -usb -device usb-kbd -device usb-tablet \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly,file=$OVMF/OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=$OVMF/OVMF_VARS-1024x768.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
	  -device ich9-ahci,id=sata \
	  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=./'Mojave/CloverNG.qcow2' \
	  -device ide-hd,bus=sata.2,drive=Clover \
	  -drive id=MacHDD,if=none,file=./mac_hdd_ng.img,format=qcow2 \
	  -device ide-hd,bus=sata.3,drive=MacHDD \
	  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
	  -monitor stdio \
	  -vnc :0 
EOF
  sed -i 's/-drive id=InstallMedia,if=none,file=BaseSystem.img,format=raw \\//g' /tmp/OSX-KVM/boot-macOS-NG.sh
else
  gsutil cp gs://baseimage/BaseSystem.img /tmp/OSX-KVM/BaseSystem.img
fi
  ./boot-macOS-NG.sh
