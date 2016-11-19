FROM alpine:3.4
MAINTAINER Kevin Smith <kevin@kevinsmith.io>

RUN apk add --update mysql-client bash && rm -rf /var/cache/apk/*
RUN mkdir /sql

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
