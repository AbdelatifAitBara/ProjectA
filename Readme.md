
![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/47753831-e500-4b53-a60a-cca916cd69f0)




# Deployement of Odoo v16, on CentOS 7, Using Vagrant, Virtualbox.


## Inroduction:

Odoo is a Belgian suite of business management software tools including, for example, CRM, e-commerce, billing, accounting, manufacturing, warehouse, project management, and inventory management.

## Prerequisites:

**Before starting, make sure you have the following:**

- Vagrant, Download from [Here](https://developer.hashicorp.com/vagrant/downloads).
- Git, Download from [Here](https://git-scm.com/downloads).
- VirtualBox, Download from [Here](https://www.virtualbox.org/wiki/Downloads).

## Project goals :

* Use Vagrant ( IaC software ), to automate the installation of our 3 VMs.
* Install OdooV.16 On 2 VMs ( SERVER 1 and SERVER 2 ).
* Install HAproxy in a 3rd machine and use it as a Loadbalancer.
* Use the reverse proxy, to send http requests to our 2 VMs, by making the SERVER1 as a master, and the 2nd one as a Slave.
* 
* Using Scripts to automotate the installation & configuration of this solution.
*
*

### IMOPORTANT:

IP Addresses of VMs:

* HAproxy  : 192.168.20.10
* SERVER 1 : 192.168.20.11
* SERVER 2 : 192.168.20.12


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


![image](https://github.com/AbdelatifAitBara/ProjectA/assets/82835348/eacdfda6-1e1b-42f1-8cff-0c5d013244d2)


