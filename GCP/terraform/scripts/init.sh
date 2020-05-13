#! /bin/bash

set -x

user(){

## Checks SKIP_USER variable
if [ "${SKIP_USER}" = "true" ]
then
  export USERNAME="disk.img"
  return
else

  # Loop to check for username file
  while [ ! -f "/tmp/username" ]
  do
    sleep 5
  done

  # Saves username to environment variable once it exists
  export USERNAME=$(cat /tmp/username)
fi

}

update() {
  apt-add-repository main
  apt-get update
}

install() {
  apt-get install qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools expect -y
  git clone https://github.com/kholia/OSX-KVM.git /OSX-KVM
}

setup() {
  cp /OSX-KVM/kvm.conf /etc/modprobe.d/kvm.conf
  
  ip tuntap add dev tap0 mode tap
  ip link set tap0 up promisc on
  ip link set dev virbr0 up
  ip link set dev tap0 master virbr0
}

check(){

if [ "${BASE_IMAGE}" = "null" ]
then
 img 
else
  if [ $(gsutil ls gs://${BUCKET}/ | grep $USERNAME) ]
  then
    ## Downloads users image and runs basestart
    gsutil cp gs://${BUCKET}/$USERNAME /$USERNAME
    basestart
    save
  else
    ## Downloads base image and runs basestart
    gsutil cp gs://${BUCKET}/${BASE_IMAGE} /$USERNAME
    basestart
    save
  fi
fi
}

img(){
 
    ## Download base image
    cd /OSX-KVM
    echo "2" | /OSX-KVM/./fetch-macOS.py

    ## Convert the base image to .img rather than .dmg
    dmg2img /OSX-KVM/BaseSystem.dmg /OSX-KVM/BaseSystem.img

    ## Use qemu to create a base image for the operating system
    qemu-img create -f qcow2 /$USERNAME 128G

    start
}

start() {
  #  /OSX-KVM/boot-macOS-NG.sh

  MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"
  MEM=$(expr $(free -mt | grep Total | awk '{print $2}') - 2048)
  CPU=$(nproc --all)

  printf "change vnc password\n%s\n" ${PASSWORD} | qemu-system-x86_64 -enable-kvm -m $MEM -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
    -machine q35 \
    -smp $CPU,cores=$CPU \
    -usb -device usb-kbd -device usb-tablet \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"\
    -drive if=pflash,format=raw,readonly,file=/OSX-KVM/OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=/OSX-KVM/OVMF_VARS-1024x768.fd \
    -smbios type=2 \
    -device ich9-intel-hda -device hda-duplex \
    -device ich9-ahci,id=sata \
    -drive id=OpenCore,if=none,snapshot=on,format=qcow2,file=/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2 -device ide-hd,bus=sata.1,drive=OpenCore\
    -drive id=InstallMedia,if=none,file=/OSX-KVM/BaseSystem.img,format=raw -device ide-hd,bus=sata.2,drive=InstallMedia\
    -drive id=MacHDD,if=none,file=/$USERNAME,format=qcow2 -device ide-hd,bus=sata.3,drive=MacHDD \
    -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
    -monitor stdio -vnc :0,password
}

basestart() {
  #  /OSX-KVM/boot-macOS-NG.sh

  MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"
  MEM=$(expr $(free -mt | grep Total | awk '{print $2}') - 2048)
  CPU=$(nproc --all)

  printf "change vnc password\n%s\n" ${PASSWORD} | qemu-system-x86_64 -enable-kvm -m $MEM -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
    -machine q35 \
    -smp $CPU,cores=$CPU \
    -usb -device usb-kbd -device usb-tablet \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"\
    -drive if=pflash,format=raw,readonly,file=/OSX-KVM/OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=/OSX-KVM/OVMF_VARS-1024x768.fd \
    -smbios type=2 \
    -device ich9-intel-hda -device hda-duplex \
    -device ich9-ahci,id=sata \
    -drive id=OpenCore,if=none,snapshot=on,format=qcow2,file=/OSX-KVM/OpenCore-Catalina/OpenCore.qcow2 -device ide-hd,bus=sata.1,drive=OpenCore\
    -drive id=MacHDD,if=none,file=/$USERNAME,format=qcow2 -device ide-hd,bus=sata.3,drive=MacHDD \
    -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
    -monitor stdio -vnc :0,password
}

save(){

  ## Pushing the users image back up once they are done using the host
  gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp /$USERNAME gs://${BUCKET}/

}

user
update
install
setup
check
