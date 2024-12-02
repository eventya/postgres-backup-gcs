FROM debian:bookworm

# Install required dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client-15 \
    curl \
    gnupg \
    cron && \
    curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-sdk && \
    apt-get clean

# Add the backup script
COPY backup.sh /scripts/backup.sh
RUN chmod +x /scripts/backup.sh

# Add the entrypoint script
COPY entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh

# Create directory for cron logs
RUN mkdir -p /var/log/cron

# Default environment variables (can be overridden at runtime)
ENV CRON_SCHEDULE="0 2 * * *"

# Start the entrypoint script
CMD ["/scripts/entrypoint.sh"]
