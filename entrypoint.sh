#!/usr/bin/env bash
set -euo pipefail
PORT="${ORCA_PORT:-6768}"
ADDR="${ORCA_PAIRING_ADDRESS:-127.0.0.1}"
echo "[orca] starting serve on :$PORT pairing-address=$ADDR"
exec xvfb-run -a --server-args="-screen 0 1440x900x24" \
  /opt/orca/AppRun --no-sandbox --disable-dev-shm-usage --disable-gpu \
  serve --port "$PORT" --pairing-address "$ADDR" ${ORCA_SERVE_EXTRA_ARGS:-}
