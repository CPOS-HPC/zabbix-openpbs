# zabbix-openpbs

A small Bash integration that reports OpenPBS problem nodes to Zabbix agent2.
It is independent of `pbs_monitor` and uses `pbsnodes -l` as its only data source.

The script reports every node returned by `pbsnodes -l`, including states such
as `down`, `offline`, and `state-unknown`. A 45-second local cache prevents each
Zabbix item from running another PBS query.

## Install

```bash
sudo install -m 0755 zabbix-openpbs /usr/local/bin/zabbix-openpbs
sudo install -m 0644 zabbix-openpbs.conf \
  /etc/zabbix/zabbix_agent2.d/zabbix-openpbs.conf
sudo systemctl restart zabbix-agent2
```

Import `zabbix-openpbs.yaml` into Zabbix and link **OpenPBS node status by
Zabbix agent** to the host running the script.

The Zabbix service account must be able to run `/opt/pbs/bin/pbsnodes -l`.
Override the command or cache settings with environment variables when needed:

```text
PBSNODES=/opt/pbs/bin/pbsnodes
CACHE_TTL=45
CACHE_DIR=/tmp/zabbix-openpbs-<uid>
```

## Verify

```bash
/usr/local/bin/zabbix-openpbs discovery
zabbix_agent2 -t openpbs.node.problem.count
zabbix_agent2 -t openpbs.node.discovery
```

## Test

```bash
./tests/test.sh
```

