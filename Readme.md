![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/e24389eb-4450-4ef7-9f05-3ce2e302bd2a)


# Deployement of Odoo v16, on CentOS 7, Using Vagrant, Virtualbox.

## Prerequisites:

**Before starting, make sure you have the following:**

- Vagrant, Download from [Here](https://developer.hashicorp.com/vagrant/downloads) ( Vagrant is an open-source software product for building and maintaining portable virtual software development environments; e.g., for VirtualBox, KVM, Hyper-V, Docker containers).
- Git, Download from [Here](https://git-scm.com/downloads) ( It is a free and open-source version control system used to handle small to very large projects efficiently. Git is used to tracking changes in the source code, enabling multiple developers to work together on non-linear development.).
- VirtualBox, Download from [Here](https://www.virtualbox.org/wiki/Downloads) ( Oracle VM VirtualBox is cross-platform virtualization software. It allows users to extend their existing computer to run multiple operating systems including Microsoft Windows, Mac OS X, Linux, and Oracle Solaris, at the same time).
- Make sure that The Virtualization Technology is enabled on your machine ( If you have an Intel processor you can check that using : [Intel® Processor Identification Utility](https://www.intel.com/content/www/us/en/download/12136/intel-processor-identification-utility-windows-version.html)  ).

In the example bellow **"Intel Virtualization Technology" is disabled**, so if is the case for you too try to activate it on your BIOS.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/eb981664-896a-45c1-854c-17b5b1817b15)


If you see that "Intel Virtualization Technology" is Enabled on your BIOS but you keep seing it disabled on Intel processor identification Utility, run this command manually using (cmd.exe) and restart your PC.
*

```
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
```



* Here "Intel Virtualization Technology" is **Enabled** :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/9c4abedf-3b5c-4f04-9c10-a12a9270ac87)

## Collaborators:

* [Abdelatif Ait Bara](https://github.com/AbdelatifAitBara)
* [Kevin B](https://github.com/pittour)
* [Yacine Ben Hamida](https://github.com/Yac19)
* [Hadi Hassan](https://github.com/hassanhadi1)

## Project Context :

- This group project is the first one of the DevOps Factory training program. After acquiring basic knowledge of Linux, Python and Bash, we had 8 days to set up a fully automated installation script.

## Project goals :

* Use Vagrant ( IaC software ), to automate the installation of our 3 VMs and the 2vHDD to use them in the LVM Solution.
* Install OdooV.16 On 2 VMs ( APP 1 and APP 2 ).
* Install HAproxy in the 3rd machine and use it as a LoadBalancer.
* Use the reverse proxy, to send http requests to our 2 VMs, by making the APP 1 as a master, and the 2nd one as a Slave.
* Create a scripts to automotate the installation & configuration of this solution.
* Create a script to automate, the back-up of data base, from the APP 1 and send it to the APP 2 using ssh protocol.
* Configuration of an auto signed certificate on the LoadBalancer, to secure the communications.
* Implement an LVM storage solution to store database data, this solution should allow flexible expansion of storage space.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/62048af5-7cb6-40dc-9100-f47ae1b3f7fb)

**With our solution you can install OdooV16 and configure it,Haproxy,Do Back-Up everyday automatically,Generate SSL Certificate, Create LVM Solution everything just with ONE CLICK.**


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/5ea08939-e20c-4f7f-b4df-71fee55fe10f)

### IMPORTANT:

IP Addresses of VMs:
* HAproxy  : 192.168.20.10
* APP 1    : 192.168.20.11
* APP 2    : 192.168.20.12

## How to clone the project, and install Odoo.v16 on your VMs :

- Open your powershell.
- Run the bellow commands in order :


```
cd .\Desktop\
```

```
git clone https://github.com/AbdelatifAitBara/ProjectA
```

```
cd .\ProjectA\
```

```
vagrant up
```

### NOTE: The Installation will take a while (Around 50 to 60mn).

- When the installation is done, open your VirtualBox, you should have the same VMs as the image bellow.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/a72ada26-b635-48c6-903e-b2af0e1701c9)


## A- Explanation of Vagrantfile:

* This file is executed when we run the "vagrant up" command. It is responsible for creating and provisioning our VMs.
* We create 3 VMs that run on CentOS 7, with 2048MB RAM and 2 CPU cores each. We also define their IP addresses and SSH parameters.
* Two of them are named (= hostname) app1 and app2 and will contain our Odoo app. They are both provisioned by the install_odoo.sh file. App1 also contains 2 additional disks because we will use LVM (Logical Volume Management) on them to store our database saves later.
* The third one named "haproxy" will be our reverse proxy that will act as a load balancer toward app1 and app2. It is provisioned by the install_haproxy.sh script.

## B- Scripts Explanation :

### 1- Explanation of "install_odoo.sh" :

This script will allow us to :

* Update&Upgrade our system automatically.
* Install Python3.7 Packages And Libraries. 
* Install Postgresql-14 client and server.
* Install WKHTMLTOX.
* Install Odoo ERP.
* Create And Activate A Python Virtual Environment To Run Odoo Software.
* Do the Post Configuration of Odoo Automatically.
* Create a Systemd Service Unit of Odoo.
* Enable and start Odoo.Service Automatically.
* Creation of LVM Solution.

NOTE: The script iS programmed to stop the installation, if one of the 10 steps goes badly.

### Explanation Step By Step :

### Step 1 :

- In this step our script will update and upgrade our system automatically.

### Step 2 : 

- In this step the script will install some packages as (openssl, openssl-devel, wget, tar, gcc, git...ect) because we need them later, also the development tools group (acts as a transitional package for installation of multiple development, compilation and debugging tools), after it will download Python3.7 as a tar file, extract it, and install it at the end.

### Step 3 : 

- In this step we are installing and setting up postgresql. We are also creating the database to be used by the odoo app. 
- Then we launch our "back-up.sh" to regulary save our database. 

### Step 4 : 

- Our script will install WKHTMLTOX needed by Odoo,is a combination of wkhtmltopdf and wkhtmltoimage, that are open source (LGPLv3) command line tools to render HTML into PDF and various image formats using the Qt WebKit rendering engine.

### Step 5 :  

- For security reasons, we should create a specific user for our application Odoo16, so our script will create an "user = odoo", after it will clone  the application inside the home of this user, and change the owner of the application folder /opt/odoo/, from root to odoo user. 

### Step 6 : 

- Inside our application folder "/opt/odoo/", the script will create a virtual environment "Odoo-venv" to run our application Odoo16, after that it wills change the owner of "Odoo-venv", later the script will activate this virtual environment, and upgrade the pip to install the requirements of Odoo16 inside our environment, and at the end our script will deactivate the virtual environment.

### Step 7 : 

- In this step our script will create 2 folders, one for the custom addons "/opt/odoo/odoo-custom-addons", and the other for logs "/var/log/odoo", and inside of this folder a file for Odoo16 logs "/var/log/odoo/odoo.log", by the end the script will change the owner of the logs folder from "root" to "odoo" user.

### Step 8 : 

- The script will transfer 2 files from our "Local Pc" to our VMs, the first file is odoo service "odoo.service" to /etc/systemd/system/odoo.service. 


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/adf386b8-006d-4a10-aafe-f6bbebb5dfc4)



- The 2nd one is the configuration file of Odoo16 "odoo.conf" to /etc/odoo.conf.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/8e58c690-b906-41b1-b3ae-f411ed409495)


### Step 9 : 

- Finally, our script will start and enable odoo.service, if that done correctly we'll be able to see the status of our odoo.service if it is active or not, we can get the IP Address that we should use to get access to our application Odoo16.

### IMPORTANT:

- At the step 9 of the instalation of Odoo on APP 1 & APP 2 make sure that Odoo.service is **ACTIVE & RUNNING** as the image bellow:

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/1842f917-7211-4b9e-8ede-4f825e9f0bd8)


### Step 10 : 

- In this step we'll create the LVM Solution on the APP 1, we do a simple check on which APP the script is runnning if is on the APP 2 we do nothing, and if is the APP 1 we move our "lvm.sh" who will allows us to create this solution automatically to our APP 1 and run it at the same time to create our 2 Logical Volumes and mount the first one on "odoo_backup".

### 2- Explanation of "install_haproxy.sh" :

This script will allow us to :

* Update&Upgrade our system automatically.
* Install HAproxy on the 3rd VM. 
* Configure HAproxy as a LoadBalancer.
* Configure the reverse proxy.
* Create a cronjob, each time we reboot our Haproxy machine, this cron will check the status of HAproxy, and if it finds that the status = inactive, it will restart haproxy.service.
* Run " pem_generate.sh " script, to create our SSL Certificate automatically.

### Explanation Step By Step :

### Step 1 : 
In this step our script will update and upgrade our system automatically.

### Step 2 : 

- The script transfert 2 files from our "LocalPc" to our Haproxy VM, "haproxy.cfg" to /etc/haproxy/haproxy.cfg this file contains the configuration of our reverse proxy ( APP 1 as a Primary Server, APP 2 as a Back-up Server, SSL Certificate ).


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/03bbaf1f-573c-455d-99a4-7067fe6982b6)




- The second file is "haproxy" to /etc/default/haproxy this file is the enable the Load Balancer's behavior.


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/4052f1a9-8184-4a15-b5a8-596acf5c157b)



- After this the script will transfer "pem_generate.sh" to /root/ssl/pem_generate.sh, this script is used to generate the PEM file, we'll use it later to secure our connection.

- If everything went well, at the end of the installation you'll have the same result as the image bellow, showing the IP address that we should use to get access to our Application :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/821157cd-e143-4a6a-b5ab-1580cd93a72a)


### 3- Explanation of "back-up.sh" :

* This script is executed periodically thanks to a crontab job. It is responsible for database backups.
* First, it checks if the LV partition exists.
* If it does, it creates a dump backup file on it. If the backup fails, we will be notified through a log file.
* It also checks if the backup folder has no more than 10 saves to avoid disk shortage. If more than 10 files are found, the older ones are deleted.
* Then, it initiates an SSH connection to app2 and saves the backup files there. It proceeds with the same file verification as previously.


### 4- Explanation of "pem_generate.sh" :

This script will allow us to automate :

- The generation of .PEM file, needed by HApoxy to be used in the encryption of requests and allows inbound requests via HTTPS Protocol ( SSL Certificate )
- The generation of files needed to generate our PEM file as : 

- private.key  : is a file that contains the private key of a pair of keys used in SSL/TLS certificates,the SSL/TLS protocol uses a pair of keys - one private, one public - to authenticate, secure and manage secure connections

- mydomain.crt : is a file that contains the SSL/TLS certificate content,SSL/TLS certificates establish an encrypted connection between a website/server and a browser with what's known as an "SSL handshake",The certificate contains information about the identity of the certificate/website owner, which is called the "subject".

### IMPORTANT :

- Self-signed certificates and certificates signed by a Certificate Authority (CA) are both used to provide encryption for data in motion, but there are some differences between them. Here are some key points from the search results:

1- Self-Signed Certificates:

- Self-signed certificate is created and authenticated by an individual or entity themselves without the involvement of a third-party CA.

- Self-signed certificates are mostly used in test environments to test the security of a network or a website, or to establish secure connections between devices for testing purposes.

- Self-signed certificates are not trusted by web browsers and can cause security warnings to appear when accessed by users.

- Self-signed certificates are great for testing environments and non-public networks, but they don't belong on the public internet.

2- Certificates Signed by a Certificate Authority:

- Certificates signed by a reputable third-party CA are more trusted than self-signed certificates for commercial use.

- A CA is an organization whose primary work is to validate the identities of individuals, companies, and any other entity. A CA is also responsible for issuing digital certificates that bind these individuals and entities to cryptographic keys.

- Certificates signed by a CA provide authentication in addition to encryption, as the CA verifies the identity of the certificate holder.

- Certificates signed by a CA are trusted by web browsers and do not cause security warnings to appear when accessed by users.




### 5- Explanation of "lvm.sh" LVM Solution :

This script will allow us to automate :

* Creation 2 PV ( Physical Volume ), PV1 & PV2 from our 2 Vhdd that we have create using our Vagrantfile ( sdb, sdc ).
* Creation of VG ( Volume Group ), using our 2 PV created in the Step 1.
* Creation of LV ( Logical Volume ), using our Volume Group create in the Step 2.
* Formatting and Mounting Our Logical Volumes.

#### LVM Architecture Example:

<img src="https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/eb3b7579-012d-450b-bd46-88e1209b2077" width="40%" height="50%">




### Explanation Step By Step :

### STEP 1 :

- We use the command "pvcreate" passing 2 block devices or partitions that will be initialized as physical volumes, we have create 2 Physical Volume. 
- This command creates a physical volume header on each device and writes metadata to the device to identify it as a physical volume.


### STEP 2 :

- The command vgcreate vg_odoo /dev/sdb /dev/sdc creates a new LVM volume group named vg_odoo and adds at least one physical volume to it
In this case, the physical volumes are /dev/sdb and /dev/sdc.
- A volume group is a pool of storage that consists of one or more physical volumes. Multiple logical volumes can then be created in a volume group.

### STEP 3 :

- The command lvcreate --size 6G --name lv1 vg_odoo creates a new logical volume named lv1 with a size of 6GB in the volume group vg_odoo.
- The command lvcreate -l 100%FREE --name lv2 vg_odoo creates a new logical volume named lv2 that uses all the remaining free space in the volume group vg_odoo.

### STEP 4 :

- The commands mkfs.ext4 /dev/vg_odoo/lv1 and mkfs.ext4 /dev/vg_odoo/lv2 format the logical volumes lv1 and lv2 with the ext4 filesystem.
- The command mount /dev/vg_odoo/lv1 /var/lib/pgsql/14/backups/odoo_backup mounts the logical volume lv1 at /var/lib/pgsql/14/backups/odoo_backup.
- The command mkdir /var/lib/pgsql/14/backups/odoo_backup/saves creates a new directory named saves inside the /var/lib/pgsql/14/backups/odoo_backup directory, will be used to save our db back-up comes from our APP 1, On The APP 2.



### 6- Problems that we have meet and solved during the creation of this solution :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/f8c726a8-0e19-4f4d-b22d-27601eca86d9)



1- We couldn't launch python3.7 inside script ( creation of python venv using only python3.7 -m ....) doesn't work, we had to add the complet path inside the script. 

2- Using vagrant user to connect to our VMs made a lot of problems during the installation of our scripts because of permissions, so we had to modify our Vagrantfile to connect as a root and run all our scripts as root.

3- Python versions problems (we had to do upgrade and downgrade to find the best version of python for our solution), inside the documentation of odoo they propose to use a version >= 3.7 but when we have used 3.9 we had a lot of problems during the installation of odoo requirements.

4- Another problem when we tried to make the creation of our 2 vHDD, "sdb" and "sdc" automatically using Vagrant, when we used the port"0" we figured out that this port is per default used by the system "CentOS", so we had to change the port to "1", but it was not enough because we was able to create only 1 vHDD, after many changes we found that the problem is the type of vHDD, we was using VDI ( Virtual Desktop Infrastructure ) ,at the end we had to change it to "vmdk" ( Virtual Machine Disk ).

5- Cannot do backup as root and to resolve this, we had to replace "peer" by "trust" inside the pg config file : pg_hba.cfg.

6- When we have transferred scripts from our LocalPC to our VMs, we got character problems "/r$" so we couldn't launch them, we figured out that editing a script on Windows and run it in Linux could create problems, so at the beginning we used VScode, and it works only one time, after that we got the same problem, that's why we had to use “sed”, to substitute the extra character at the end of lines.

7- Deploying the app2 before the app1, we had a problem because the app 1 needs to connect with the app2 and if we launch the app1 and the app 2 is not available it will block our installation.

8- The same problem when we deployed our 2 apps before HAproxy, so we had to change the order of deployement of our APPS and keep the HAproxy at the end. 




![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/71e73768-66b1-4ee4-89cf-e23f55ab4234)
