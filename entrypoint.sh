#!/bin/bash
# Exit on any error
set -e

# Export all environment variables to a file for the cron job
env | grep -v CRON_SCHEDULE | grep -v PATH | grep -v _= > /scripts/env

# Write the cron job schedule to a file
echo "$CRON_SCHEDULE . /scripts/env && /scripts/backup.sh >> /var/log/cron/backup.log 2>&1" > /etc/cron.d/postgres-backup

# Give execution rights on the cron job
chmod 0644 /scripts/env
chmod 0644 /etc/cron.d/postgres-backup

# Apply the cron job
crontab /etc/cron.d/postgres-backup

# Start the cron service
echo "Starting cron with schedule: $CRON_SCHEDULE"
cron -f
