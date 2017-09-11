#!/bin/bash

set -e

#
# Check required environment variables
#

REQUIRED=( SRC_HOST SRC_USER SRC_PASS SRC_NAME DEST_HOST DEST_USER DEST_PASS DEST_NAME )

for i in "${REQUIRED[@]}"
do
  if [ -z "${!i}" ]; then
      echo -e "Environment variable ${i} is required, exiting..."
      exit 1
  fi
done

#
# Sync source to destination
#

while ! mysqladmin ping -h "${SRC_HOST}" --silent; do
    echo -e "MySQL server at ${SRC_HOST} not ready, trying again later..."
    sleep 1
done

echo -e "Exporting source database."
mysqldump \
  --user="${SRC_USER}" \
  --password="${SRC_PASS}" \
  --host="${SRC_HOST}" \
  "${SRC_NAME}" \
  > /sql/dump.sql

while ! mysqladmin ping -h "${DEST_HOST}" --silent; do
    echo -e "MySQL server at ${DEST_HOST} not ready, trying again later..."
    sleep 1
done

echo -e "Clearing destination database."
mysqldump \
  --user="${DEST_USER}" \
  --password="${DEST_PASS}" \
  --host="${DEST_HOST}" \
  --add-drop-table \
  --no-data "${DEST_NAME}" | \
  grep -e ^DROP -e FOREIGN_KEY_CHECKS | \
  mysql \
  --user="${DEST_USER}" \
  --password="${DEST_PASS}" \
  --host="${DEST_HOST}" \
  "${DEST_NAME}"

echo -e "Loading export into destination database."
mysql \
  --user="${DEST_USER}" \
  --password="${DEST_PASS}" \
  --host="${DEST_HOST}" \
  "${DEST_NAME}" \
  < /sql/dump.sql

echo -e "Sync completed."
