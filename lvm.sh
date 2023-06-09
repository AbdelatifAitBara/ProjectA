#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
BBlue='\033[1;34m'
NC='\033[0m'

printf "${BBlue}STEP 1: Adding the Disk to LVM PV...${NC}\n"
if
pvcreate /dev/sdb
pvcreate /dev/sdc
then
    printf "${GREEN}STEP 1: LVM Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 1...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 2: Creating LVM VG...${NC}\n"
if
vgcreate vg_odoo /dev/sdb /dev/sdc
then
    printf "${GREEN}STEP 2: LVM VG Has Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 2...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 3: Creating LVM LV...${NC}\n"
if
lvcreate --size 6G --name lv1 vg_odoo
lvcreate -l 100%FREE --name lv2 vg_odoo
then
    printf "${GREEN}STEP 3: LVM LV 1 and 2 Have Been Installed Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 3...${NC}\n"
    exit 1
fi

printf "${BBlue}STEP 4: Formatting and Mounting Logical Volumes...${NC}\n"
if
mkfs.ext4 /dev/vg_odoo/lv1
mkfs.ext4 /dev/vg_odoo/lv2
mount /dev/vg_odoo/lv1 /var/lib/pgsql/14/backups/odoo_backup
mkdir /var/lib/pgsql/14/backups/odoo_backup/saves
then
    printf "${GREEN}STEP 4: Logical Volumes Have Been Formatted and Mounted Successfully.${NC}\n"
else
    printf "${RED}Error: During The STEP 4...${NC}\n"
    exit 1
fi

