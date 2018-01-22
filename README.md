# Memory-bounded Pre-copy Live Migration (MPLM) of Virtual Machines
<p><p>
Kasidit Chanchio <br>
Contact: kasiditchanchio@gmail.com <br>
Department of computer science <br>
Faculty of science and technology <br>
Thammasat University.
<p>
Memory-bound Pre-copy Live Migration (MPLM) is a pre-copy migration mechanism that incorporate a new algorithm to overlaps VM computation and VM state transfer in a best-effort manner. We implement MPLM in a modified version of QEMU 2.9.0, namely <b>qemu-mplm</b>, available at this web site. This software is provided mainly for educational purposes. Please refer to the official QEMU software at https://www.qemu.org/ for more information about qemu.    
<ul>
 <li> <a href="#part1">1. Compile qemu-mplm</a>
      <ul>
       <li> <a href="#prepare">1.1 Prerequisites</a>
       <li> <a href="#configure">1.2 Configure</a>
       <li> <a href="#make">1.3 Compile and install</a>
      </ul>
 <li> <a href="#part2">2. Run and Migrate VMs</a> 
      <ul>
       <li> <a href="#createVM">2.1 Create a VM</a>
       <li> <a href="#installAppOnVM">2.2 Install NPB on the VM</a>
       <li> <a href="#destVM">2.3 Run a destination VM to wait for VM state</a>
       <li> <a href="#srcVM">2.4 Run a source VM</a>
       <li> <a href="#migVM">2.5 Perform a migration</a> 
       <li> <a href="#Perf">2.6 MPLM Performance Report</a> 
      </ul>
 <li><a href="#part3">3. Summary</a>
</ul>
<p>
<a id="part1"><h3>1. Compilation</h3></a>
<p><p>
<p>
 <i><a id="prepare"><h4>1.1 Prerequisites</h4></a></i>
<p> 
I am doing this on Ubuntu 16.04 server (64 bits). 
<pre>
$ sudo apt-get update
$ sudo apt-get install libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libaio-dev libbluetooth-dev
$ sudo apt-get install libbrlapi-dev libbz2-dev  libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev libibverbs-dev libjpeg8-dev
$ sudo apt-get install libncurses5-dev libnuma-dev librbd-dev librdmacm-dev libsasl2-dev libsdl1.2-dev libseccomp-dev
$ sudo apt-get install libsnappy-dev libssh2-1-dev libvde-dev libvdeplug-dev libvte-dev libxen-dev liblzo2-dev valgrind xfslibs-dev
</pre>
<p>
 <i><a id="configure"><h4>1.2 Configure</h4></a></i>
<p> 
<pre>
$ git clone https://github.com/kasidit/qemu-mplm
$ cd qemu-mplm
$ mkdir build
</pre>
Next, we create a directory for qemu-mplm installation.  
<pre>
$ mkdir /home/kasidit/qemu-mplm-bin
</pre>
Next, I am going to install KVM-enabled qemu software for x86_64-softmmu and x86_64-linux-user architectures. The installation directory is /home/kasidit/qemu-mplm-bin.
<pre>
$ cd build
$ ../configure -h
$ ../configure --enable-kvm --prefix=/home/kasidit/qemu-mplm-bin --target-list=x86_64-softmmu,x86_64-linux-user
</pre>
 <p>
 <i><a id="make"><h4>1.3 Compile and install qemu-mplm</h4></a></i>
<p>
<pre>
$ make
$ sudo make install
</pre>
Now, we have a new qemu hypervisor for MPLM migration installed. In qemu-mplm, the traditional pre-copy mechanism is replaced by MPLM. You can perform an MPLM migration the same way you operate pre-copy migration in QEMU; however, you <b>DO NOT</b> have to provide (or estimate) <b>the maximum tolerable downtime parameter</b> for the migration. The MPLM mechanism eliminates the needs for this parameter and enables automatic migration.     
<p>
<a id="part2"><h3>2. Create, Run, and Migrate a VM</h3></a>
<p><p>
<p>
<i><a id="createVM"><h4>2.1 Create a VM</h4></a></i>
<p> 
First, I'm going to create a new ubuntu virtual machine image with the following commands. If you already have a VM image, you cam skip this part. 
<pre>
$ cd 
$ mkdir images
$ cd images
$ wget http:... // get the ubuntu server image
$ ls 
ubuntu-16.04.3-server-amd64.iso
$
$ qemu-img create -f qcow2 ubuntu1604qcow2.img 8G
Formatting 'ubuntu1604qcow2.img', fmt=qcow2 size=8589934592 encryption=off cluster_size=65536 lazy_refcounts=off refcount_bits=16
$ pwd
/home/kasidit/images
$
</pre>
I basically create an image directory, retrieve ISO image of ubuntu 16.04 server from internet, and create a qcow2 image for VM image installation. 
<p><p>
Next, I am going to run a VM to install ubuntu 16.04 on the ubuntu1604qcow2.img image file.
<pre>
$ sudo /home/kasidit/qemu-mplm-bin/bin/qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 2G \
>  -drive file=/home/kasidit/images/ubuntu1604qcow2.img,format=qcow2 -boot d -cdrom ubuntu-16.04.3-server-amd64.iso \
>  -vnc :95 -net nic -net user -monitor tcp::9666,server,nowait -localtime &
$
</pre>
Next, I am going to invoke the tightVNC viewer client program on my notebook and enter the IP address of the server with VNC port 95 as VNC server URL. After the VNC screen shows up, I will install ubuntu 16.04 and we will continue in the next section. When finish the installation, you can terminate the VM using the following command on the host machine. 
<pre>
$ echo quit | nc localhost 9666
</pre>
I am going to run the VM again with the command below. Notice that we set vcpu cores to 4 and memory size to 16GB. 
<pre>
$ sudo /home/kasidit/qemu-mplm-bin/bin/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 <b>-m 16G</b> \
>  -drive file=/home/kasidit/images/ubuntu1604qcow2.img,format=qcow2 -boot c -vnc :95 -net nic -net user \
>  -monitor tcp::9666,server,nowait -localtime &
$
</pre>
I recommend creating shell scripts for these commands. 
<p>
<i><a id="installAppOnVM"><h4>2.2 Install NPB on the VM</h4></a></i>
<p>
Next, I am going to log in to the VM via the VNC client. 
After loggin into the VM, we will install the <a href="https://www.nas.nasa.gov/publications/npb.html">NAS Parallel Benchmark (NPB) benchmark</a> on it. Assuming "vm$>" is the VM's command line prompt, we compile the OpenMP version of the kernel BT of the NAS benchmark with commands below.  
<pre>
vm$> sudo sed -i "s/us.arch/th.arch/g" /etc/apt/sources.list
vm$> sudo apt-get update 
vm$> sudo apt-get install gcc gfortran
vm$> wget https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz
vm$> gzip -d NPB3.3.1.tar.gz
vm$> tar xvf NPB3.3.1.tar
vm$> cd NPB3.3.1
vm$> cd NPB3.3-OMP
vm$> cd config
vm$> 
</pre>
We first obtain source codes of the NPB software from NASA website and then extract it. 
Next, we change directory to $HOME/NPB3.3.1/NPB3.3-OMP/config. We will build the applications using the Makefile here. 
We have to create two files before using make utility to build application binaries. They are make.def and suite.def. 
The make.def file defines the compilers and compilation options, while suite.def defines 
a list of pairs of application name and class of data users want to build. Fortunately, the NPB authors have already 
provide examples make.def and suite.def for various systems and bechmark selections for us in 
the $HOME/NPB3.3.1/NPB3.3-OMP/config/NAS.sample/ directory. We can just copy them to $HOME/NPB3.3.1/NPB3.3-OMP/config.
<pre>
vm$> pwd
$HOME/NPB3.3.1/NPB3.3-OMP/config
vm$>
vm$> cp NAS.samples/make.def.gcc_x86 make.def
vm$> cp NAS.samples/suite.def.bt suite.def
</pre>
Then, we compile the openMP version of the BT kernel. In the example suite.def above, we will build 6 BT benchmark 
programs. They are the BT Class A, B, C, D, S, W. The binaries would be stored in the $HOME/NPB3.3.1/NPB3.3-OMP/bin 
directory. 
<pre>
vm$> cd $HOME/NPB3.3.1/NPB3.3-OMP
vm$> sudo apt install make
vm$> 
vm$> make suite
...
vm$> ls bin
bt.A.x bt.B.x bt.C.x ...
vm$>
</pre>
We will repeat similar steps to compile the SP benchmarks below. 
<pre>
vm$> cd config
vm$> cp NAS.samples/suite.def.sp suite.def
vm$> cd ..
vm$> make suite
...
</pre>
</pre>
Now, we have the BT and SP applications installed. You can test both of them  using the following commands.
<pre>
vm$> ./bin/bt.B.x
...
vm$> ./bin/sp.A.x
...
vm$>
</pre>
You can compile and run more benchmarks in the VMs as you wish. At this point, we are going to stop the VM for now. 
<pre>
$ echo quit | nc localhost 9666
</pre>
<p>
<i><a id="destVM"><h4>2.3 Run a destination VM to wait for VM state</h4></a></i>
<p> 
In this section, we are going to setup another host computer to be a destination computer. First, we follows instructions in section 1 to prepare and compile qemu-mplm software on the destination host. Next, we will copy the image file from the source host to destination host. Supposed that the IP address of the destination host is 192.100.20.3 and the login account there is kasidit, we will use the following commnads to do so. 
<p><p>
 <b>On the destination host:</b>
<pre>
$ mkdir /home/kasidit/images
</pre>
<p><p>
 <b>On the source host:</b>
<pre>
$ cd /home/kasidit/images
$ scp ubuntu1604qcow2.img kasidit@192.100.20.3:/home/kasidit/images
</pre>
<p><p>
 <b>On the destination host:</b>
<p><p>
On the destination machine, we invoke qemu to wait for state transfer from the source. You can also run a vnc client 
to view the VM's console. This VM wait for a connection from a migraing VM on port 8698. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/runKvmUserNet-incoming.sh">runKvmUserNet-incoming.sh</a>)
<pre>
$ sudo /home/kasidit/qemu-mplm-bin/bin/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=/home/kasidit/images/ubuntu1604qcow2.img,format=qcow2 -boot c -vnc :95 \
  -monitor tcp::9666,server,nowait \
  -net nic -net user \
  -localtime \
 <b>-incoming tcp::8698</b> &
$
</pre>
<p>
<i><a id="srcVM"><h4>2.4 Run a source VM</h4></a></i>
<p>
 Next, we will run the source VM on the source host. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/runKvmUserNet.sh">runKvmUserNet.sh</a>)
<p><p>
 <b>On the source host:</b>
<pre>
$ sudo /home/kasidit/qemu-mplm-bin/bin/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=/home/kasidit/images/ubuntu1604qcow2.img,format=qcow2 -boot c -vnc :95 \
  -monitor tcp::9666,server,nowait \
  -net nic -net user \
  -localtime > migreport.txt &
$
</pre>
<p><p>
 <b>On the VM:</b><br>
We will also run an application (BT Class C)on the VM. 
<pre>
vm$> cd NPB3.3.1/NPB3.3-OMP
vm$> ./bin/bt.C.x
</pre>
<p>
<i><a id="migVM"><h4>2.5 Perform an MPLM migration</h4></a></i>
<p><p>
 <b>2.5.1 Default Migration:</b> <br>
<p>
MPLM is defined to be the default migration implementation of our modified QEMU here. To perform a migration, you can invoke the following command.
<p>
<b>On the source host:</b><br>
<pre>
$ echo "migrate -d tcp:192.100.20.3:8698" | nc localhost 9666
</pre>
QEMU will report migration performance to stdout. You can also view status and migration performance using a command below.
<pre>
$ echo "info migrate" | nc localhost 9666
</pre>
<p>
 <b>2.5.2 Migration using QMP (sending JSON-based instructions):</b> <br>
<p>
You can also use QMP to send instruction to QEMU to perform a migraiton. If you wan to start the waiting VM at the destination with deferred-incoming migration mode (that will defer the specification of listening TCP port until the migration is about to occur), you have to run the destination VM with the following commands. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/runKvmUserNet-incoming-defer.sh">runKvmUserNet-incoming-defer.sh</a>)
<pre>
$ sudo /home/kasidit/qemu-mplm-bin/bin/qemu-system-x86_64 -enable-kvm -cpu host -smp 4 -m 16G \
  -drive file=/home/kasidit/images/ubuntu1604qcow2.img,format=qcow2 -boot c -vnc :95 \
  -monitor tcp::9666,server,nowait \
  -net nic -net user \
  -localtime \
 <b>-incoming defer</b> &
$
</pre>
<p>
At a migration event, you have to run the incoming migration command on the destination host using the following commands. 
 (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/qmp-migincoming.sh">qmp-migincoming.sh</a>)
<p>
<b>On the destination host:</b>
<pre>
$ echo "{ \"execute\": \"qmp_capabilities\" } 
      { \"execute\": \"migrate-incoming\", 
        \"arguments\": { \"uri\": \"tcp::8698\" } }" | socat UNIX-CONNECT:./qmp-sock-9666 STDIO
</pre>
<p>
On the source host, you would invoke the following command to start a migration. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/qmp-migrate.sh">qmp-migrate.sh</a>) 
<p>
<b>On the source host:</b> 
<pre>
$ echo "{ \"execute\": \"qmp_capabilities\" } 
      { \"execute\": \"migrate\", 
        \"arguments\": { \"uri\": \"tcp:192.100.20.3:8698\" } }" | socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
</pre>
<p>
 <b>2.5.3 MPLM Live Migration Extension:</b> <br>
<p>
MPLM allows users to extend live migration operation until they instruct otherwise. To enable the continuation of live migration stage 
beyond normal MPLM live migration, you have to issue the following QMP command before MPLM ending conditions 
are satisfied. It is safe to issue the command before or when the migration is launched. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/qmp-set-mplm-extend-live.sh">qmp-set-mplm-extend-live.sh</a>)
<pre>
$ echo "{ \"execute\": \"qmp_capabilities\" } 
        { \"execute\": \"set-mplm-extend-live\" }" | nc -U ./qmp-sock-9666 
</pre>
<p>
When you want to stop the extended live migration operation, you have to issue the following command. (See <a href="https://github.com/kasidit/qemu-mplm/blob/master/migration/MPLM/qmp-set-mplm-end-live.sh">qmp-set-mplm-end-live.sh</a>
<pre>
$ echo "{ \"execute\": \"qmp_capabilities\" } 
        { \"execute\": \"set-mplm-end-live\" }" | nc -U ./qmp-sock-9666 
</pre>
MPLM will stop live migration stage and enter the last migration stage, the stop and copy operation. 
<p>
<i><a id="Perf"><h4>2.6 MPLM Performance Report</h4></a></i>
<p> 
During the migration, MPLM reports its operating status to the "migreport.txt" file. An example of the file 
generated during a migration of a VM running the LU benchmark is provided at 
 <a href="">TBA</a>. (Explanation coming soon!) 
<p>
<a id="part3"><h3>3. Summary</h3></a>
<p>
We have shown how to install and use MPLM for a migration. We plan to publish more information about MPLM including its designs and performance evaluation in a near future.  
