#!/bin/bash
binloc=/home/kasidit/qemu-mplm-mplcr-bin/bin
imgloc=/home/kasidit/images
#
rm ${imgloc}/ub1604-mplcr-layer2-qcow2.ovl
${binloc}/qemu-img create -f qcow2 -b ${imgloc}/ub1604-mplcr-qcow2.ovl ${imgloc}/ub1604-mplcr-layer2-qcow2.ovl
#
sudo ${binloc}/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=${imgloc}/ub1604-mplcr-layer2-qcow2.ovl,format=qcow2 -boot c -vnc :97 \
  -qmp unix:./qmp-sock-9777,server,nowait \
  -monitor unix:./moni-sock-9777,server,nowait \
  -net nic -net user \
  -localtime \
  -incoming cptcp::8698 | tee dest-migreport-mplm.txt 
#  -incoming cptcp::8698 | tee dest-migreport-mplm.txt &
