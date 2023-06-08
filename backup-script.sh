#!/bin/bash

DB_NAME="test1"
APP_NAME="odoo-back-up"
BACKUP_DIR="/var/lib/pgsql/14/backups"
DESTINATION_SERVER="root@192.168.20.12"
DESTINATION_DIRECTORY="/var/lib/pgsql/14/backups/remote_backup"

# Set the backup filename with timestamp

BACKUP_FILE="${BACKUP_DIR}/odoo_backup/${APP_NAME}-$(date +%Y-%m-%d-%H-%M-%S).dump"

# Set the log file name
log_file="${BACKUP_DIR}/backup.log"

# Run the pg_dump command and redirect the output to /dev/null
if ! pg_dump -U postgres -w -Fc test1 > "${BACKUP_FILE}" 2>> "${log_file}"; then
  echo "The backup for ${current_date} has failed." >> "${log_file}"
  exit 1
fi

# Copy the backup file to the destination server using SCP
if ! scp "$BACKUP_FILE" "$DESTINATION_SERVER":"$DESTINATION_DIRECTORY"; then
  echo "The remote backup on ${DESTINATION_SERVER} for ${current_date} has failed." >> "${log_file}"
  exit 1
fi

# Check if the files number is inferior to 10 and delete older files
cd "$BACKUP_DIR/odoo_backup"
files=($(ls ${BACKUP_DIR}/odoo_backup -t))
files_num=${#files[@]}
remove_num=$((files_num - 10))

if [ $remove_num -gt 0 ]; then
    files_to_remove=("${files[@]: -remove_num}")
    echo "${files_to_remove[@]}"
    rm "${files_to_remove[@]}"
fi

ssh "$DESTINATION_SERVER" << EOF
    cd "$DESTINATION_DIRECTORY"

    files=($(ls ${DESTINATION_DIRECTORY} -t))
    files_num=${#files[@]}
    remove_num=$((files_num - 10))

    if [ $remove_num -gt 0 ]; then
        files_to_remove=("${files[@]: -$remove_num}")
        echo "${files_to_remove[@]}"
        rm "${files_to_remove[@]}"
    fi
EOF