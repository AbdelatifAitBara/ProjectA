#!/bin/bash
###########################INFORATIONS##############################
# -Project A: Deployment of Odoo V16 on CentOS7                    #
# -Script INFO : This script will Deploy the application Odoo V16  #
# on CentOS7 and run it on venv of python3.7.13.                   #
# Odoo V16 will use pg-14 as db and haproxy as a loadbalancer.     #
# -Developer: DevOps Team - B - Team-B@itsgroup.fr                 #
# -Date: 04/06/2023                                                #
# -Version: 3.0.0                                                  #
####################################################################
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BBlue='\033[1;34m'
NC='\033[0m'
password="vagrant"

printf "${GREEN}Please be patient, the installation will takes a few minutes...${NC}\n"
printf "${CYAN}This Script Contains 9 STEPS To Deploy The Application Odoo Ver.16.${NC}\n"

printf "${BBlue}STEP 1: Updating and Upgrading The System...${NC}\n"
if sudo yum -y update && sudo yum -y upgrade
then
    printf "${GREEN}STEP 1: The System Has Been Updated successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 1...${NC}\n"
    exit 1 
fi

printf "${BBlue}STEP 2: Installing Python3.7 Packages And Libraries...${NC}\n"
if

yum install -y nano bzip2-devel openssl openssl-devel wget tar gcc git libpq-devel python-devel openldap-devel libffi-devel xz-devel zlib-devel
sudo yum -y groupinstall "Development Tools"
wget https://www.python.org/ftp/python/3.7.13/Python-3.7.13.tgz
tar xvf Python-3.7.13.tgz
cd Python-3.7.13
./configure --enable-optimizations
sudo make altinstall
then
    printf "${GREEN}STEP 2: Python3.7 Packages And Libraries Installation Done Successfully...${NC}\n"
else
    printf "${RED}Error: During The STEP 2...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 3: Installing Postgresql-14...${NC}\n"
if


sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y update
sudo yum install -y postgresql14-server postgresql14
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl start postgresql-14.service
systemctl enable postgresql-14.service
su - postgres -c "createuser -s odoo"
su - postgres -c "createdb test1"
sed -i 's/peer/trust/g' /var/lib/pgsql/14/data/pg_hba.conf
systemctl restart postgresql-14.service
if [[ "$1" == "app2" ]];then
    mkdir /var/lib/pgsql/14/backups/remote_backup
elif [[ "$1" == "app1" ]];then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    sshpass -p "${password}" ssh-copy-id -o StrictHostKeyChecking=no root@192.168.20.12
    cp /vagrant/backup-script.sh /var/lib/pgsql/14/backups/backup-script.sh
    chmod +x /var/lib/pgsql/14/backups/backup-script.sh
    mkdir /var/lib/pgsql/14/backups/odoo_backup
    echo "* * * * * /var/lib/pgsql/14/backups/backup-script.sh" >> pg-back-up
    crontab pg-back-up
    rm -f pg-back-up
fi
then
    printf "${GREEN}STEP 3: Postgresql-14 Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 3...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 4: Installing WKHTMLTOX...${NC}\n"
if
cd /tmp
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox-0.12.6.1-2.almalinux9.x86_64.rpm
yum localinstall -y wkhtmltox-0.12.6.1-2.almalinux9.x86_64.rpm
then
    printf "${GREEN}STEP 4: WKHTMLTOX Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 4...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 5: Installing Odoo ERP...${NC}\n"
if
sudo useradd -r -m -U -s /bin/bash -d /opt/odoo odoo
cd /opt/odoo/
git clone https://www.github.com/odoo/odoo --depth 1 --branch 16.0 --single-branch
chown -R odoo: /opt/odoo/
then
    printf "${GREEN}STEP 5: Odoo-V.16 ERP Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 5...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 6: Create And Activate A Python Virtual Environment For Odoo Software...${NC}\n"
if
cd /opt/odoo
/usr/local/bin/python3.7 -m venv Odoo-venv
chown -R odoo: Odoo-venv/
source Odoo-venv/bin/activate
pip install --upgrade pip
pip install -r /opt/odoo/odoo/requirements.txt
deactivate
then
    printf "${GREEN}STEP 6: The Python Virtual Environment Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 6...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 7: Post Installation Configuration...${NC}\n"
if
mkdir /opt/odoo/odoo-custom-addons
mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown -R odoo: /var/log/odoo/

then
    printf "${GREEN}STEP 7: Post Installation Configuration Has Successfully Done.${NC}\n"
else
    printf "${RED}Error: During The STEP 7...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 8: Create a Systemd Service Unit And The Odoo.Config File...${NC}\n"

if
cp /vagrant/odoo.service /etc/systemd/system/odoo.service
cp /vagrant/odoo.conf /etc/odoo.conf
then
    printf "${GREEN}STEP 8: The Systemd Service Unit and The Odoo.Config Have Been Created Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 8...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 9: Start Odoo.Service And Enable It...${NC}\n"
if
systemctl start odoo.service
systemctl enable odoo.service
then
    systemctl status odoo.service
    printf "${GREEN}To get access to Odoo Use: http://$(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p'):8069 ${NC}\n"
else
    printf "${RED}Error: During The STEP 9...${NC}\n"
    exit 1
fi