FROM debian:8.7
MAINTAINER Kevin Smith <kevin@kevinsmith.io>

# Install the MySQL client
RUN apt-get update && apt-get install -y --no-install-recommends \
    mysql-client \

  # Cleanup
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /sql

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
