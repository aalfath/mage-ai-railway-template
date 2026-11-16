#!/bin/bash
# Railway wrapper for the official Mage AI image.
# Sets safe defaults, keeps the project and data on the /home/src volume,
# then hands over to the image's own start script (/app/run_app.sh).
set -eo pipefail

# Project files and block output live on the volume mounted at /home/src.
export USER_CODE_PATH="${USER_CODE_PATH:-/home/src/default_repo}"
export MAGE_DATA_DIR="${MAGE_DATA_DIR:-/home/src/mage_data}"

# Login is required unless the deployer explicitly turns it off.
export REQUIRE_USER_AUTHENTICATION="${REQUIRE_USER_AUTHENTICATION:-1}"
export DISABLE_AUTO_BROWSER_OPEN="${DISABLE_AUTO_BROWSER_OPEN:-1}"

# Mage falls back to the owner login admin / admin when no password is set.
# Refuse to start a public instance with that default.
case "${REQUIRE_USER_AUTHENTICATION,,}" in
  0|false|no) ;;
  *)
    if [ -z "${DEFAULT_OWNER_PASSWORD}" ] || [ "${DEFAULT_OWNER_PASSWORD}" = "admin" ]; then
      echo "DEFAULT_OWNER_PASSWORD is empty or 'admin'. Set a strong password before starting Mage." >&2
      exit 1
    fi
    ;;
esac

mkdir -p "${MAGE_DATA_DIR}"
cd /home/src
exec /app/run_app.sh
