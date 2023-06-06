#!/bin/bash

if


sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y update
sudo yum install -y postgresql14-server postgresql14
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl start postgresql-14.service
systemctl enable postgresql-14.service
su - postgres -c "createuser -s odoo"
sed -i 's/peer/trust/g' /var/lib/pgsql/14/data/pg_hba.conf
systemctl restart postgresql-14.service
cp /vagrant/back-up.sh /var/lib/pgsql/14/backups
mkdir /var/lib/pgsql/14/backups/odoo_backup
echo "* * * * * /var/lib/pgsql/14/backups/back-up.sh" >> pg-back-up
crontab pg-back-up
rm -f pg-back-up

then
echo "Success"
else
echo "Error"
fi