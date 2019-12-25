#! /bin/bash

set -x

#cd ~/
#wget http://f.jdclab.pw/files/macOS_Mojave_10.14.dmg
#wget http://f.jdclab.pw/files/Clover-v2.4k-4644-X64.iso
#git clone https://github.com/kholia/OSX-KVM.git
#qemu-img create -f qcow2 mac_hdd.img 64G
#
#cat <<EOF > ~/clover.cfg
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#	<key>Boot</key>
#	<dict>
#		<key>Arguments</key>
#		<string></string>
#		<key>DefaultVolume</key>
#		<string>clover</string>
#		<key>Log</key>
#		<true/>
#		<key>Secure</key>
#		<false/>
#		<key>Timeout</key>
#		<integer>3</integer>
#	</dict>
#	<key>GUI</key>
#	<dict>
#		<key>Scan</key>
#		<dict>
#			<key>Entries</key>
#			<true/>
#			<key>Tool</key>
#			<true/>
#		</dict>
#		<key>ScreenResolution</key>
#		<string>1920x1080<string>
#		<key>Theme</key>
#		<string>embedded</string>
#	</dict>
#	<key>RtVariables</key>
#	<dict>
#		<key>BooterConfig</key>
#		<string>0x28</string>
#		<key>CsrActiveConfig</key>
#		<string>0x3</string>
#	</dict>
#	<key>SMBIOS</key>
#	<dict>
#		<key>Trust</key>
#		<false/>
#	</dict>
#	<key>SystemParameters</key>
#	<dict>
#		<key>InjectKexts</key>
#		<false/>
#		<key>InjectSystemID</key>
#		<true/>
#	</dict>
#</dict>
#</plist>
#EOF
#sudo ~/OSX-KVM/HighSierra/./clover-image.sh --iso ~/Clover-v2.4k-4644-X64.iso --cfg ~/clover.cfg --img Clover.cow2
#
#
#
#
#cat<<EOF > ~/boot.sh
##! /bin/bash
#
#MY_OPTIONS="+aes,+xsave,+avx,+xsaveopt,avx2,+smep"
#
#qemu-system-x86_64 -enable-kvm -m 3072 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
#	  -machine pc-q35-2.9 \
#	  -smp 4,cores=2 \
#	  -usb -device usb-kbd -device usb-tablet \
#	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
#	  -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd \
#	  -drive if=pflash,format=raw,file=OVMF_VARS-1024x768.fd \
#	  -smbios type=2 \
#	  -device ich9-intel-hda -device hda-duplex \
#	  -device ide-drive,bus=ide.2,drive=Clover \
#	  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=./'/home/jcampbell/Clover.cow2' \
#	  -device ide-drive,bus=ide.1,drive=MacHDD \
#	  -drive id=MacHDD,if=none,file=./mac_hdd.img,format=qcow2 \
#	  -device ide-drive,bus=ide.0,drive=MacDVD \
#	  -drive id=MacDVD,if=none,snapshot=on,media=cdrom,file=./'home/jcampbell/macOS_Mojave_10.14.iso' \
#	  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
#	  -monitor stdio
#EOF
#
#sudo ~/./boot.sh

grep -cw vmx /proc/cpuinfo
