#!/bin/bash

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
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --reload
then
    cp /vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
    sudo haproxy -f /etc/haproxy/haproxy.cfg
    systemctl start haproxy.service
    systemctl enable haproxy.service
    echo "@reboot sleep 60 && systemctl status haproxy.service || systemctl restart haproxy.service" >> check-haproxy
    crontab check-haproxy 
    printf "${GREEN}STEP 2: HA Proxy Has Been Installed&Configured Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 2...${NC}\n"
    exit 1
fi
