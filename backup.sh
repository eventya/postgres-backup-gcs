#!/bin/bash

set -e

# Required environment variables
POSTGRES_HOST=${POSTGRES_HOST:-localhost}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
BACKUP_DIR=${BACKUP_DIR:-/backup}
DATE=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME-$DATE.sql.gz"
GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

# Validate required variables
if [ -z "$POSTGRES_DATABASE" ] || [ -z "$POSTGRES_USER" ] || [ -z "$BACKUP_NAME" ] || [ -z "$GCS_BUCKET" ]; then
  echo "Missing required environment variables." >&2
  exit 1
fi

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Perform the backup
echo "Creating backup for database $POSTGRES_DATABASE..."
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_DATABASE | gzip > "$BACKUP_FILE"

# Activate google credentials
echo "Activating google credentials before beginning"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

if [ $? -ne 0 ] ; then
    echo "Credentials failed; no way to copy to google."
    echo "Ensure GOOGLE_APPLICATION_CREDENTIALS is appropriately set."
fi


# Upload to Google Cloud Storage
echo "Uploading $BACKUP_FILE to GCS bucket $GCS_BUCKET..."
gsutil cp "$BACKUP_FILE" "gs://$GCS_BUCKET/"

# Remove local backup file
echo "Removing local backup file $BACKUP_FILE..."
rm "$BACKUP_FILE"

echo "Backup completed successfully."

exit $?
