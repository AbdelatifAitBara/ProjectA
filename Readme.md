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

git clone https://github.com/AbdelatifAitBara/ProjectA

cd .\Desktop\ProjectA

vagrant up

```
### NOTE: The Installation will take a while (Around 50 to 60mn).

At the end of the Installation, open your VirtualBox, you should have the same VMs as the image bellow.

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
* Start Odoo.Service And Enable Automatically

NOTE: The script is capable to stop the installation, if any step of 9 goes badly.

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
* Create a SSL Certificate automatically.

### Explanation Step By Step :

### Step 1 : 
In this step our script will update and upgrade our system automatically.

### Step 2 : 

The script transfert 2 files from our "LocalPc" to our Haproxy VM, "haproxy.cfg" to /etc/haproxy/haproxy.cfg this file contains the configuration of our reverse proxy ( APP 1 as a Primary Server, APP 2 as a Back-up Server, SSL Certificate ).
![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/ea3d2c35-281a-45d4-98d2-674a21911e0e)


The second file is "haproxy" to /etc/default/haproxy this file is the enable the Load Balancer's behavior.

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/4052f1a9-8184-4a15-b5a8-596acf5c157b)



![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/eacdfda6-1e1b-42f1-8cff-0c5d013244d2)

After this the script will transfer "pem_generate.sh" to /root/ssl/pem_generate.sh, this script is used to generate the PEM file, we'll use it later to secure our connection.

## LVM Solution Explanation [lvm.sh] :

### STEP 1 :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/cd6c41fc-dbfe-41b5-9d3e-f343812842ba)

### STEP 2 :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/9ac574fa-b8fc-4573-bce7-cbf0dd228667)


### STEP 3 :

![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/18be8d21-e9a6-40aa-8a55-a859881861db)


### STEP 4 :

