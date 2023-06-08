#!/bin/bash

###########################INFORATIONS##############################
# -Project A: Deployment of Odoo V16 on CentOS7                    #
# -Script INFO : This script will install HAproxy on CentOS7, and  #
# configure it to be used as a load balancer.                      #
# Server 1: will be the master, Server 2 is the slave.             #
# If the Server 1 goes DOWN, Haproxy will send all the requests to #
# Server 2.                                                        #
# -Developer: DevOps Team - B - Team-B@itsgroup.fr                 #
# -Date: 07/06/2023                                                #
# -Version: 1.0.0                                                  #
####################################################################


GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BBlue='\033[1;34m'
NC='\033[0m'

printf "${GREEN}Please be patient this may take a while...${NC}\n"
printf "${BBlue}STEP 1: Updating and Upgrading The System...${NC}\n"


if sudo yum -y update && sudo yum -y upgrade
then
    printf "${GREEN}STEP 1: The System Has Been Updated successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 1...${NC}\n"
    exit 1 
fi

printf "${BBlue}STEP 2: Instalation&Configuration of HAProxy ...${NC}\n"
if  
    sudo yum -y install haproxy
    #firewall-cmd --zone=public --add-port=8069/tcp --permanent
    #firewall-cmd --reload
then
    cp /vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
    cp /vagrant/haproxy /etc/default/haproxy
    mkdir /root/ssl
    cp /vagrant/pem_generate.sh /root/ssl/pem_generate.sh
    chmod +x /root/ssl/pem_generate.sh
    sed -i -e 's/\r$//' /root/ssl/pem_generate.sh
    bash /root/ssl/pem_generate.sh mydomain
    systemctl enable haproxy.service
    systemctl start haproxy.service
    echo "@reboot sleep 60 && systemctl status haproxy.service || systemctl restart haproxy.service" >> check-haproxy
    crontab check-haproxy 
    printf "${GREEN}STEP 2: HA Proxy Has Been Installed&Configured Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 2...${NC}\n"
    exit 1
fi
