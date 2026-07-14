#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

cat >"$TEMP_DIR/pbsnodes" <<'EOF'
#!/usr/bin/env bash
[[ "${1:-}" == "-l" ]] || exit 2
cat <<'NODES'
compute02            state-unknown,down
compute03            offline
NODES
EOF
chmod +x "$TEMP_DIR/pbsnodes"

run() {
    PBSNODES="$TEMP_DIR/pbsnodes" CACHE_DIR="$TEMP_DIR/cache" CACHE_TTL=300 \
        "$ROOT/zabbix-openpbs" "$@"
}

[[ $(run count) == 2 ]]
[[ $(run problem compute02) == 1 ]]
[[ $(run problem compute01) == 0 ]]
[[ $(run state compute03) == offline ]]
[[ $(run state compute01) == healthy ]]

discovery=$(run discovery)
[[ "$discovery" == *'"{#PBSNODE}":"compute02"'* ]]
[[ "$discovery" == *'"{#PBSSTATE}":"offline"'* ]]

echo "All tests passed"

