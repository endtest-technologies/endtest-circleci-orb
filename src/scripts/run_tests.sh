#!/usr/bin/env bash
set -euo pipefail

APP_ID="${!ENDTEST_APP_ID_ENV}"
APP_CODE="${!ENDTEST_APP_CODE_ENV}"

if [ -z "${APP_ID}" ]; then
  echo "Missing Endtest App ID. Please set ${ENDTEST_APP_ID_ENV} in CircleCI."
  exit 1
fi

if [ -z "${APP_CODE}" ]; then
  echo "Missing Endtest App Code. Please set ${ENDTEST_APP_CODE_ENV} in CircleCI."
  exit 1
fi

if [ -z "${ENDTEST_API_REQUEST}" ]; then
  echo "Missing Endtest API request."
  exit 1
fi

echo "Starting Endtest execution..."
echo "API request: ${ENDTEST_API_REQUEST}"
echo "Polling loops: ${ENDTEST_NUMBER_OF_LOOPS}"

# Temporary first version.
# This validates and publishes the orb structure.
# We will replace this with the real Endtest API call and polling logic next.

exit 0
