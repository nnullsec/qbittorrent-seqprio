#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$ROOT/custom-services.d" "$ROOT/config/scripts"

cat > "$ROOT/config/scripts/apply_seq_prio.sh" <<'EOF'
#!/bin/bash
set -e

HASH="$1"
COOKIE="$(mktemp)"
trap 'rm -f "$COOKIE"' EXIT

curl -sS \
  -c "$COOKIE" \
  -H "Referer: $QBT_URL" \
  --data-urlencode "username=$QBT_USER" \
  --data-urlencode "password=$QBT_PASS" \
  "$QBT_URL/api/v2/auth/login" \
  -o /dev/null

curl -sS \
  -b "$COOKIE" \
  -H "Referer: $QBT_URL" \
  --data-urlencode "hashes=$HASH" \
  "$QBT_URL/api/v2/torrents/toggleSequentialDownload" \
  -o /dev/null

curl -sS \
  -b "$COOKIE" \
  -H "Referer: $QBT_URL" \
  --data-urlencode "hashes=$HASH" \
  "$QBT_URL/api/v2/torrents/toggleFirstLastPiecePrio" \
  -o /dev/null
EOF

cat > "$ROOT/custom-services.d/seqprio" <<'EOF'
#!/usr/bin/with-contenv bash
set -e

sleep 10

COOKIE="$(mktemp)"

curl -sS \
  -c "$COOKIE" \
  -H "Referer: $QBT_URL" \
  --data-urlencode "username=$QBT_USER" \
  --data-urlencode "password=$QBT_PASS" \
  "$QBT_URL/api/v2/auth/login" \
  -o /dev/null

curl -sS \
  -b "$COOKIE" \
  -H "Referer: $QBT_URL" \
  --data-urlencode \
  'json={"autorun_on_torrent_added_enabled":true,"autorun_on_torrent_added_program":"/config/scripts/apply_seq_prio.sh %I"}' \
  "$QBT_URL/api/v2/app/setPreferences" \
  -o /dev/null

rm -f "$COOKIE"
exec sleep infinity
EOF

chmod 755 \
  "$ROOT/config/scripts/apply_seq_prio.sh" \
  "$ROOT/custom-services.d/seqprio"

chown 1000:10 "$ROOT/config/scripts/apply_seq_prio.sh"
chown root:root "$ROOT/custom-services.d/seqprio"

docker restart qbittorrent
