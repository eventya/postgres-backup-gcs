# Database Backup Script

This repository contains a shell script to back up a PostgreSQL database and upload the backup to Google Cloud Storage.

## Prerequisites

- PostgreSQL installed and configured
- Google Cloud SDK installed and configured
- Environment variables set for PostgreSQL and Google Cloud credentials

## Environment Variables

The following environment variables need to be set before running the script:

- `POSTGRES_DATABASE`: Name of the PostgreSQL database to back up
- `POSTGRES_USER`: PostgreSQL user
- `POSTGRES_PASSWORD`: Password for the PostgreSQL user
- `POSTGRES_HOST`: Host of the PostgreSQL database
- `POSTGRES_PORT`: Port of the PostgreSQL database
- `BACKUP_NAME`: Name prefix for the backup file
- `BACKUP_DIR`: Directory to store the backup file (default: `/backup`)
- `GCS_BUCKET`: Google Cloud Storage bucket name
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to the Google Cloud service account key file

## Usage

1. Clone the repository:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Set the required environment variables:
    ```sh
    export POSTGRES_DATABASE=<your-database>
    export POSTGRES_USER=<your-user>
    export POSTGRES_PASSWORD=<your-password>
    export POSTGRES_HOST=<your-host>
    export POSTGRES_PORT=<your-port>
    export BACKUP_NAME=<your-backup-name>
    export GCS_BUCKET=<your-gcs-bucket>
    export GOOGLE_APPLICATION_CREDENTIALS=<path-to-your-service-account-key-file>
    ```

3. Run the backup script:
    ```sh
    ./backup.sh
    ```

## Alternative option using Docker

[https://hub.docker.com/layers/eventyapublisher/postgres-backup-gcs](https://hub.docker.com/r/eventyapublisher/postgres-backup-gcs)


## License

This project is licensed under the MIT License.


## Docker

- build - `docker build --platform="linux/amd64" -t eventyapublisher/postgres-backup-gcs .`
- push - `docker push eventyapublisher/postgres-backup-gcs`


## Bash
- shell - `kamal accessory exec postgres-backup --interactive --reuse "bash"`