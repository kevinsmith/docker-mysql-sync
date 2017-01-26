FROM debian:8.7
MAINTAINER Kevin Smith <kevin@kevinsmith.io>

# Install the MySQL client
RUN apt-get update && apt-get install -y --no-install-recommends \
    mysql-client \

  # Cleanup
  && rm -rf /var/lib/apt/lists/*

# Add Tini (the tiny init https://github.com/krallin/tini)
ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN mkdir /sql

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
