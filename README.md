# qemu-mplm


Kasidit Chanchio <br>
Contact: kasiditchanchio@gmail.com <br>
Department of computer science <br>
Faculty of science and technology <br>
Thammasat University.

<p>
<h2>A modified QEMU 2.9.0 software to support Memory-bounded Pre-copy Live Migration (MPLM) of Virtual Machines</h2> <br>
<p>
This software is provided for educational purposes. Please refer to the official QEMU software at https://www.qemu.org/.    
<ul>
 <li> 1. <a href="#part1">1. Compilation</a>
      <ul>
       <li> <a href="#prepare">1.1 Prepre dependency</a>
       <li> <a href="#configure">1.2 Configure</a>
       <li> <a href="#make">1.3 Compile and install</a>
      </ul>
 <li> 2. <a href="#part2">2. Rum VMs and perform a migration</a> 
      <ul>
       <li> <a href="#destVM">2.1 Run a destination VM to wait for VM state</a>
       <li> <a href="#srcVM">2.2 Run a source VM</a>
       <li> <a href="#migVM">2.3 Perform a migration </a> 
      </ul>
 <li><a href="#part3">3. Summary</a>
</ul>
<p>
<a id="part1"><h3>1. Compilation</h3></a>
<p><p>
<p>
 <i><a id="prepare"><h4>1.1 Prepre dependency</h4></a></i>
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
$ cd build
</pre>
I am goint to install the binary at create /home/kasidit/qemu-mplm-bin directory. 
<pre>
$ mkdir /home/kasidit/qemu-mplm-bin
</pre>
Next. I am going to configure parameters for the installation. Basically, I am going to install KVM-enabled qemu software for x86_64-softmmu and x86_64-linux-user architectures. The installation directory will be at /home/kasidit/qemu-mplm-bin.
<pre>
$ ../configure -h
$ ../configure --enable-kvm --prefix=/home/kasidit/qemu-mplm-bin --target-list=x86_64-softmmu,x86_64-linux-user
</pre>
 <p>
 <i><a id="make"><h4>1.3 Compile and install</h4></a></i>
<p>
<pre>
$ make
$ sudo make install
</pre>
<p>
<a id="part2"><h3>2. Rum VMs and perform a migration</h3></a>
<p><p>  
<p>
<i><a id="destVM"><h4>2.1 Run a destination VM to wait for VM state</h4></a></i>
<p> 
<p>
<i><a id="srcVM"><h4>2.2 Run a source VM</h4></a></i>
<p> 
<p>
<i><a id="migVM"><h4>2.3 Perform a migration</h4></a></i>
<p>
<p>
<a id="part3"><h3>3. Summary</h3></a>
<p>
