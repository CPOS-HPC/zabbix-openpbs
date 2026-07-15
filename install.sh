#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
    echo "Run this installer as root." >&2
    exit 1
fi

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=/etc/zabbix/scripts
CONF_DIR=/etc/zabbix/zabbix_agent2.d

install -d -m 0755 "$SCRIPT_DIR" "$CONF_DIR"
install -m 0755 "$ROOT_DIR/zabbix-openpbs" "$SCRIPT_DIR/zabbix-openpbs"
install -m 0644 "$ROOT_DIR/zabbix-openpbs.conf" "$CONF_DIR/zabbix-openpbs.conf"

echo "Installed $SCRIPT_DIR/zabbix-openpbs"
echo "Installed $CONF_DIR/zabbix-openpbs.conf"
echo
echo "IMPORTANT: Restart zabbix-agent2 to activate this installation:"
echo "  sudo systemctl restart zabbix-agent2"
echo "The new OpenPBS checks will not work until the service is restarted."
