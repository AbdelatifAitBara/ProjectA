#!/bin/bash

DB_NAME="phenix"
APP_NAME="Odoo-back-up"
BACKUP_DIR="/var/lib/pgsql/14/backups/odoo_backup"

# Set the backup filename with timestamp

BACKUP_FILE="$BACKUP_DIR/$APP_NAME-$(date +%Y-%m-%d-%H-%M-%S)"

pg_dump -U postgres -w -Fc $DB_NAME > $BACKUP_FILE.dump