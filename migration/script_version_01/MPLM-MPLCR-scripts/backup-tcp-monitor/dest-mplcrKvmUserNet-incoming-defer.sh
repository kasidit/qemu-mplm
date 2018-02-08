#!/bin/bash
binloc=/home/kasidit/qemu-mplm-mplcr-bin/bin
imgloc=/home/kasidit/images
#
sudo ${binloc}/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=${imgloc}/ubuntu1604qcow2.img,format=qcow2 -boot c -vnc :96 \
  -qmp unix:./qmp-sock-9777,server,nowait \
  -monitor tcp::9777,server,nowait \
  -net nic -net user \
  -incoming defer \
  -localtime | tee migreport.txt 
#  -localtime > migreport.txt &
