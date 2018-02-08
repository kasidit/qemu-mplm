#!/bin/bash
binloc=/home/kasidit/qemu-mplm-mplcr-bin/bin
imgloc=/home/kasidit/images
#
sudo ${binloc}/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=${imgloc}/ubuntu1604qcow2.ovl,format=qcow2 \
  -boot c -vnc :95 \
  -qmp unix:./qmp-sock-9666,server,nowait \
  -monitor tcp::9666,server,nowait \
  -net nic -net user \
  -localtime | tee migreport.txt 
#  -localtime > migreport.txt &
