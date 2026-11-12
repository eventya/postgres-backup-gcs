FROM debian:bookworm

# pg_dump must match the server's major version: an older pg_dump refuses a newer
# server, and a newer one writes dumps an older server may not load. Debian bookworm
# ships only 15, so the client comes from PostgreSQL's own repository. Each major is
# its own tag: build with --build-arg PG_MAJOR=16 and push as :16.
ARG PG_MAJOR=16

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    cron && \
    install -d /usr/share/postgresql-common/pgdg && \
    curl -fsSLo /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y postgresql-client-$PG_MAJOR google-cloud-cli && \
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
