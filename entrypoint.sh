#!/bin/bash

SOURCE_DB_HOST=${SOURCE_DB_HOST}
SOURCE_DB_USER=${SOURCE_DB_USER}
SOURCE_DB_PASS=${SOURCE_DB_PASS}
SOURCE_DB_NAME=${SOURCE_DB_NAME}

TARGET_DB_HOST=${TARGET_DB_HOST}
TARGET_DB_USER=${TARGET_DB_USER}
TARGET_DB_PASS=${TARGET_DB_PASS}
TARGET_DB_NAME=${TARGET_DB_NAME}

# Preflight checks
if [[ ${SOURCE_DB_HOST} == "" ]]; then
  echo "The SOURCE_DB_HOST env variable is required."
  exit 1
fi
if [[ ${SOURCE_DB_USER} == "" ]]; then
  echo "The SOURCE_DB_USER env variable is required."
  exit 1
fi
if [[ ${SOURCE_DB_PASS} == "" ]]; then
  echo "The SOURCE_DB_PASS env variable is required."
  exit 1
fi
if [[ ${SOURCE_DB_NAME} == "" ]]; then
  echo "The SOURCE_DB_NAME env variable is required."
  exit 1
fi
if [[ ${TARGET_DB_HOST} == "" ]]; then
  echo "The TARGET_DB_HOST env variable is required."
  exit 1
fi
if [[ ${TARGET_DB_USER} == "" ]]; then
  echo "The TARGET_DB_USER env variable is required."
  exit 1
fi
if [[ ${TARGET_DB_PASS} == "" ]]; then
  echo "The TARGET_DB_PASS env variable is required."
  exit 1
fi
if [[ ${TARGET_DB_NAME} == "" ]]; then
  echo "The TARGET_DB_NAME env variable is required."
  exit 1
fi

echo -e "Exporting source database."
mysqldump \
  --user="${SOURCE_DB_USER}" \
  --password="${SOURCE_DB_PASS}" \
  --host="${SOURCE_DB_HOST}" \
  "${SOURCE_DB_NAME}" \
  > /sql/dump.sql

echo -e "Clearing target database."
mysqldump \
  --user="${TARGET_DB_USER}" \
  --password="${TARGET_DB_PASS}" \
  --host="${TARGET_DB_HOST}" \
  --add-drop-table \
  --no-data "${TARGET_DB_NAME}" | \
  grep -e ^DROP -e FOREIGN_KEY_CHECKS | \
  mysql \
  --user="${TARGET_DB_USER}" \
  --password="${TARGET_DB_PASS}" \
  --host="${TARGET_DB_HOST}" \
  "${TARGET_DB_NAME}"

echo -e "Loading export into target database."
mysql \
  --user="${TARGET_DB_USER}" \
  --password="${TARGET_DB_PASS}" \
  --host="${TARGET_DB_HOST}" \
  "${TARGET_DB_NAME}" \
  < /sql/dump.sql

echo -e "Sync completed."
