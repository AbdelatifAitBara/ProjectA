![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/e24389eb-4450-4ef7-9f05-3ce2e302bd2a)


# Deployement of Odoo v16, on CentOS 7, Using Vagrant, Virtualbox.


## Inroduction:

- Odoo is a Belgian suite of business management software tools including, for example, CRM, e-commerce, billing, accounting, manufacturing, warehouse, project management, and inventory management.
- Odoo is famous for its continuous advancement in the ERP domain, always presenting user-friendly upgrades to its users. The latest version of Odoo is currently Odoo 16, which was released in October 2022. 

## Prerequisites:

**Before starting, make sure you have the following:**

- Vagrant, Download from [Here](https://developer.hashicorp.com/vagrant/downloads) ( Vagrant is an open-source software product for building and maintaining portable virtual software development environments; e.g., for VirtualBox, KVM, Hyper-V, Docker containers).
- Git, Download from [Here](https://git-scm.com/downloads) ( It is a free and open-source version control system used to handle small to very large projects efficiently. Git is used to tracking changes in the source code, enabling multiple developers to work together on non-linear development.).
- VirtualBox, Download from [Here](https://www.virtualbox.org/wiki/Downloads) ( Oracle VM VirtualBox is cross-platform virtualization software. It allows users to extend their existing computer to run multiple operating systems including Microsoft Windows, Mac OS X, Linux, and Oracle Solaris, at the same time).

## Project goals :

* Use Vagrant ( IaC software ), to automate the installation of our 3 VMs.
* Install OdooV.16 On 2 VMs ( APP 1 and APP 2 ).
* Install HAproxy in the 3rd machine and use it as a LoadBalancer.
* Use the reverse proxy, to send http requests to our 2 VMs, by making the APP 1 as a master, and the 2nd one as a Slave.
* Create Scripts to automotate the installation & configuration of this solution.
* Create a script to automate, the back-up of data base, from the APP 1 and send it to the APP 2 using ssh protocol.
* Configuration of an auto signed certificate on the LoadBalancer, to secure the communications.
* Implement an LVM storage solution to store database data, this solution should allow flexible expansion of storage space.

### IMOPORTANT:

IP Addresses of VMs:
* HAproxy  : 192.168.20.10
* APP 1 : 192.168.20.11
* APP 2 : 192.168.20.12

## How to clone the project, and install Odoo.v16 in your VM:

- Open your powershell.
- Lunch the bellow commands in order :


```
cd .\Desktop\
```

```
git clone https://github.com/AbdelatifAitBara/ProjectA
```

```
cd .\Desktop\ProjectA\
```

```
vagrant up
```

### NOTE: The Installation will take a while (Around 50 to 60mn).

### IMPORTANT:

- At the step 9 of the instalation of Odoo on APP 1 & APP 2 make sure that Odoo.service is **ACTIVE & RUNNING** as the image bellow:

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/1842f917-7211-4b9e-8ede-4f825e9f0bd8)



- When the installation is done, open your VirtualBox, you should have the same VMs as the image bellow.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/a72ada26-b635-48c6-903e-b2af0e1701c9)


## 

## Scripts Explanation :

### 1- Explanation of "install_odoo.sh" :

This script will allow us to :

* Update&Upgrade our system automatically.
* Install Python3.7 Packages And Libraries. 
* Install Postgresql-14 client and server.
* Install WKHTMLTOX.
* Create And Activate A Python Virtual Environment To Run Odoo Software.
* Do the Post Configuration of Odoo Automatically.
* Create a Systemd Service Unit of Odoo.
* Enable and start Odoo.Service Automatically.

NOTE: The script is capable to stop the installation, if any step of 10 goes badly.

### Explanation Step By Step :

### Step 1 : 
In this step our script will update and upgrade our system automatically.
### Step 2 : 
In this step the script will install some packages as (openssl, openssl-devel, wget, tar, gcc, git...ect) because we need them later, also the development tools group (acts as a transitional package for installation of multiple development, compilation and debugging tools), after it will download Python3.7 as a tar file, extract it, and install it at the end.
### Step 3 : 
In this step we are installing and setting up postgresql. We are also creating the database to be used by the odoo app. Then, the script create a remote directory on app2 that will host the app backups. We also do the same on app1. We create a ssh connexion between app1 and app2 by creating a key pair and copying the public key on the authorized_keys file in app2. This way, app1 can send (or receive) files through ssh without requiring any password. Moreover, we add the backup script on app1. This script, when executed creates a backup dump file on app1 and on remote app2. It also checks if there is max 10 backup files remaining and deleting the elder ones on both apps (max 10).
### Step 4 : 
Our script will install WKHTMLTOX needed by Odoo,is a combination of wkhtmltopdf and wkhtmltoimage, that are open source (LGPLv3) command line tools to render HTML into PDF and various image formats using the Qt WebKit rendering engine.
### Step 5 :  
For security reasons, we should create a specific user for our application Odoo16, so our script will create an "user = odoo", after it will clone the application inside the home of this user, and change the owner of the application folder /opt/odoo/, from root to odoo user. 
### Step 6 : 
Inside our application folder "/opt/odoo/", the script will create a virtual environment "Odoo-venv" to run our application Odoo16, after that it wills change the owner of "Odoo-venv", later the script will activate this virtual environment, and upgrade the pip to install the requirements of Odoo16 inside our environment, and at the end our script will deactivate the virtual environment.
### Step 7 : 
In this step our script will create 2 folders, one for the custom addons "/opt/odoo/odoo-custom-addons", and the other for logs "/var/log/odoo", and inside of this folder a file for Odoo16 logs "/var/log/odoo/odoo.log", by the end the script will change the owner of the logs folder from "root" to "odoo" user.
### Step 8 : 
The script will transfer 2 files from our "Local Pc" to our VMs, the first file is odoo service "odoo.service" to /etc/systemd/system/odoo.service , and the 2nd one is the configuration file of Odoo16 "odoo.conf" to /etc/odoo.conf.
### Step 9 : 
Finally, our script will start and enable odoo.service, if that done correctly we'll be able to see the status of our odoo.service if it is active or not, we can get the IP Address that we should use to get access to our application Odoo16.

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


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/ea3d2c35-281a-45d4-98d2-674a21911e0e)


- The second file is "haproxy" to /etc/default/haproxy this file is the enable the Load Balancer's behavior.


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/4052f1a9-8184-4a15-b5a8-596acf5c157b)



![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/eacdfda6-1e1b-42f1-8cff-0c5d013244d2)

- After this the script will transfer "pem_generate.sh" to /root/ssl/pem_generate.sh, this script is used to generate the PEM file, we'll use it later to secure our connection.

- If everything went well, at the end of the installation you'll have the same result as the image bellow, showing the IP address that we should use to get access to our Application :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/21ad760c-e5ce-4d0c-b54e-4eaea17cb6b5)

### 3- Explanation of "pem_generate.sh" :

This script will allow us to automate :

- The generation of .PEM file, needed by HApoxy to be used in the encryption of requests and allows inbound requests via HTTPS Protocol ( SSL Certificate )
- The generation of files needed to generate our PEM file as : 

- private.key  : is a file that contains the private key of a pair of keys used in SSL/TLS certificates,the SSL/TLS protocol uses a pair of keys - one private, one public - to authenticate, secure and manage secure connections

- mydomain.crt : is a file that contains the SSL/TLS certificate content,SSL/TLS certificates establish an encrypted connection between a website/server and a browser with what's known as an "SSL handshake",The certificate contains information about the identity of the certificate/website owner, which is called the "subject".

- rootCA.key   : refers to the private key of a root certificate authority (CA), a root certificate is a public key certificate that identifies a root certificate authority (CA).

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




### 4- Explanation of "lvm.sh" LVM Solution :

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



### 5- Problems that we have meet and solved during the creation of this solution :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/f8c726a8-0e19-4f4d-b22d-27601eca86d9)



1- We couldn't lunch python3.7 inside script ( creation of python venv using only python3.7 -m ....) doesn't work, we had to add the complet path inside the script. 

2- Using vagrant user to connect to our VMs made a lot of problems during the installation of our scripts because of permissions, so we had to modify our Vagrantfile to connect as a root and run all our scripts as root.

3- Python versions problems (we had to do upgrade and downgrade to find the best version of python for our solution), inside the documentation of odoo they propose to use a version >= 3.7 but when we have used 3.9 we had a lot of problems during the installation of odoo requirements.

4- Cannot do backup as root and to resolve this, we had to replace "peer" by "trust" inside the pg config file : pg_hba.cfg.

5- problem of using scripts, when we transfer them from our LocalPC to our VMs because of character $/r, we had to use “sed”

6- Deploying the app2 before the app1, we had a problem because the app 1 needs to connect with the app2 and if we lunch the app1 and the app 2 is not available it will not work.

7- the same problem with whene we deployed our apps before HAproxy, so we had to change the order of deployement of our APPS and keep the HAproxy at the end. 


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/71e73768-66b1-4ee4-89cf-e23f55ab4234)
