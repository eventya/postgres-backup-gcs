#!/bin/bash

# Write the cron job schedule to a file
echo "$CRON_SCHEDULE /scripts/backup.sh >> /var/log/cron/backup.log 2>&1" > /etc/cron.d/postgres-backup

# Give execution rights on the cron job
chmod 0644 /etc/cron.d/postgres-backup

# Apply the cron job
crontab /etc/cron.d/postgres-backup

# Start the cron service
echo "Starting cron with schedule: $CRON_SCHEDULE"
cron -f
