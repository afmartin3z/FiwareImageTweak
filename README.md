# FiwareImageTweak
This is intended to create new FIWARE Lab Images from a base image Ubuntu 18.04. It consists in a serie of scripts which do things to the image. These scripts are not intended to work in Mac or Windows Systems because they don't have any KVM implementation (nor expected to implement in future).

As prerequisites we'll need a Linux Operating System (this was developed in Ubuntu 18.04 and Ubuntu 20.04) with a few packages installed:

* libvirt ->  ```$ sudo apt-get install libvirt-bin libvirt-doc```
* qemu and qemu-utils ->  ```$ sudo apt-get install qemu qemu-utils qemu-kvm```
* libguestfs-tools ->  ```$ sudo apt-get install libguestfs-tools```
* Driver nbd
* openstackclient ->  ```$ sudo apt-get install python-openstackclient```
* glance ->  ```$ sudo apt-get install glance```

There is a file with the name of __dooo__ shows the steps (after we have an image to work on). We can download an image as shown in step 1.

## Steps to install FIWARE Orion and Cygnus-ngsi in an image
1. Download the base image from Openstack (I like to use this one):

   ```aedbfe19-19c0-4e63-a6f9-422014843515 --file /var/lib/libvirt/images/base_ubuntu_18_04.qcow2```

   This image already has the security enhancements from FIWARE Lab Images. For example it has no root access using SSH, no passwords, only users ubuntu and support can access to it, etc.

   List of available images:
   ```$ glance image-list```

   Download the image:
   ```$ glance image-download  --file ./base_ubuntu_18_04.qcow2 aedbfe19-19c0-4e63-a6f9-42201484351```

2. We should resize image with __resizeImage.sh__ script. As show, the image is pretty small, it only has 2Gb or

     ```$ qemu-img  info base_ubuntu_18.04.qcow2
     image: base_ubuntu_18.04.qcow2
     file format: qcow2
     virtual size: 2.2G (2361393152 bytes)
     disk size: 145M
     cluster_size: 65536
     Format specific information:
       compat: 0.10
       refcount bits: 16
    ```
    The image could be too small to host the new software, so it would be good to resize it, let's say 3Gb is enough in this example (Openstack can grow images later, of course. 3Gb is the space needed to install the new software for this new image):

    ```$ sudo ./resizeImage.sh base_ubuntu_18_04.qcow2 6```

	This way, the image get resized to the 6Gb, which is the minimum in this case (if it were only orion, with 3 or 4Gb would have been enough.

    Move the image to /var/lib/libvirt/images

    ```$ sudo mv base_ubuntu_18_04.qcow2 /var/lib/libvirt/images/```

3. We set the bootstrap service in the VM, so it can run the _install.sh_ script when it boots the 1st time. We inject the install.sh script and we also can add a password in order to debug it if needed (__setPassword.sh__ script). The scripts to configure this are: __setBootstrapService.sh__ which adds a service to the startup so it executes a script when it exits and __setInstall.sh__ whis injects the _install.sh_ script.
   ```
   $ sudo ./setInstall.sh /var/lib/libvirt/images/base_ubuntu_18_04.qcow2  ./bootstrap.sh ./runApp.sh
   ...
   $ sudo ./setBootstrapService.sh /var/lib/libvirt/images/base_ubuntu_18_04.qcow2
   ....
   $ sudo ./setPassword.sh /var/lib/libvirt/images/base_ubuntu_18_04.qcow2
   ....
   ```
	Some considerations about the installation script later.

4. We create a Virtual Machine using libvirt/kvm with this image so it can install and do the things it needs to do (in this case running the script for installation:

    ```sudo ./runIt.sh  /var/lib/libvirt/images/base_ubuntu_18_04.qcow2```

	This is going to be a long task. In the case shown here, it will upgrade the whole system, install docker, docker-swarm and will start 4 dockers: 2 MongoDBs, 1 Orion and 1 Cygnus-ngsi. After the installation is done, the VM will poweroff.

5. Cleanup everything in the image: The bootstrap.sh service and the password (the password was set only with debugging purposes).

   ```$ sudo ./unsetBootstrapService.sh  /var/lib/libvirt/images/base_ubuntu_18_04.qcow2```
   ```$ sudo ./unsetPassword.sh  /var/lib/libvirt/images/base_ubuntu_18_04.qcow2```

6. We can finally upload the new image to Openstack, if we want to:

   ``` 
    $ openstack image create --disk-format qcow2 --container-format bare --public \
    --file /var/lib/libvirt/images/base_ubuntu_18_04.qcow2 ubuntu18.04.docker.fiware
   ```

## Script install.sh
This script is done "ad-hoc" to characterize the image we want to build. In this case, its name is _bootstrap.sh_ and it does a few tasks:

* Upgrades the image
* Installs some software (including docker and docker-swarm)
* Deploys 4 dockers

But it will be different for different cases. So, a new one should be writen for every different case.

Take a look at the script __dooo__ which shows the steps quite clearly.
