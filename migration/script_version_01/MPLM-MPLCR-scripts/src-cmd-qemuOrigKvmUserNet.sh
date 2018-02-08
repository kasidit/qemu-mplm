#!/bin/bash
binloc=/home/kasidit/qemu-290-bin/bin
imgloc=/home/kasidit/images
#
cp ${imgloc}/ub1604-q290-qcow2.ovl.orig ${imgloc}/ub1604-q290-qcow2.ovl
#
sudo ${binloc}/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=${imgloc}/ub1604-q290-qcow2.ovl,format=qcow2 \
  -boot c -vnc :96 \
  -qmp unix:./qmp-sock-9666,server,nowait \
  -monitor unix:./moni-sock-9666,server,nowait \
  -net nic -net user \
  -localtime | tee migreport-q290.txt 
#  -localtime > migreport.txt &
#  -monitor tcp::9666,server,nowait \
